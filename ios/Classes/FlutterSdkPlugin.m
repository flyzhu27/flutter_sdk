#import "FlutterSdkPlugin.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

__weak FlutterSdkPlugin* _sdkPlugin;

@interface FlutterSdkPlugin () <WXApiDelegate>

@end

@implementation FlutterSdkPlugin {
    FlutterMethodChannel *_flutterChannel;
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _flutterChannel = channel;
        _sdkPlugin = self;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"pockyt.io/flutter"
            binaryMessenger:[registrar messenger]];
    FlutterSdkPlugin* instance = [[FlutterSdkPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"registerWechatApi" isEqualToString:call.method]) {
        NSString *appId = call.arguments[@"appId"];
        NSString *universalLink = call.arguments[@"universalLink"];
        bool success = [WXApi registerApp:appId universalLink:universalLink];
        result(@(success));
    } else if ([@"isWechatInstalled" isEqualToString:call.method]) {
        result(@(WXApi.isWXAppInstalled));
    } else if ([@"requestWechatPay" isEqualToString:call.method]) {
        PayReq *req = [[PayReq alloc] init];
        NSString * appId = call.arguments[@"appid"];
        req.openID = (appId == (id) [NSNull null]) ? nil : appId;
        req.partnerId = call.arguments[@"partnerid"];
        req.prepayId = call.arguments[@"prepayid"];
        req.nonceStr = call.arguments[@"noncestr"];
        NSString *timeStamp = call.arguments[@"timestamp"];
        req.timeStamp = [timeStamp intValue];
        req.package = call.arguments[@"package"];
        req.sign = call.arguments[@"sign"];
        [WXApi sendReq:req completion: nil];
        result(nil);
    } else if ([@"requestAlipay" isEqualToString:call.method]) {
        NSString *payInfo = call.arguments[@"payInfo"];
        NSString *scheme = [self fetchUrlScheme];
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] payOrder:payInfo fromScheme:scheme callback:^(NSDictionary *resultDic) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf onReturnPayResult:resultDic];
        }];
    } else if ([@"isAlipayInstalled" isEqualToString:call.method]) {
        result(@(self.isAlipayInstalled));
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)onReturnPayResult:(NSDictionary*)resultDic{
    [self->_flutterChannel invokeMethod:@"onAlipayResp" arguments:resultDic];
}

-(NSString*)fetchUrlScheme{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray* types = infoDic[@"CFBundleURLTypes"];
    for(NSDictionary* dic in types){
        if([@"alipay" isEqualToString:dic[@"CFBundleURLName"]]){
            return dic[@"CFBundleURLSchemes"][0];
        }
    }
    return nil;
}

-(BOOL)isAlipayInstalled{
   return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]]||[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handlePayResultOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self handlePayResultOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self handlePayResultOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:(void (^)(NSArray *_Nonnull))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (BOOL)handlePayResultOpenURL:(NSURL *)url {
    if (!_sdkPlugin) {
        return NO;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付宝支付回调
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      __strong typeof(weakSelf) strongSelf = weakSelf;
                                                      [strongSelf onReturnPayResult:resultDic];
                                                  }];

        return YES;
    } else  if ([url.host isEqualToString:@"pay"]) {
        // 微信支付回调
        return [WXApi handleOpenURL:url delegate:self];
    }
    return NO;
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req {
    // 微信请求
}

- (void)onResp:(BaseResp *)resp {
    // 微信响应
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        NSDictionary *resultDic = @{@"errCode": @(response.errCode), @"errStr": response.errStr ?: @""};
        [self->_flutterChannel invokeMethod:@"onWechatPayResp" arguments:resultDic];
    }
}

@end
