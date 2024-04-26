import 'dart:async';
import 'dart:io';
import 'package:pockyt_pay/pockyt_pay.dart';
import 'package:pockyt_pay/src/method_channel/flutter_sdk_platform_interface.dart';

class PockytPay {
  late StreamSubscription<BaseResp>? _subscription;
  final FlutterSdkPlatform flutterPlatform = FlutterSdkPlatform.instance;

  void onSubscriber<T extends BaseResp>(void Function(T) onResponse) {
    _subscription = flutterPlatform.responseEventHandler
        .where((event) => event is T)
        .cast<T>()
        .listen(onResponse);
  }

  void offSubscriber() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<bool> registerWechatApi({
    required String appId,
    String? universalLink,
  }) async {
    assert(
    !Platform.isIOS || (universalLink?.isNotEmpty ?? false),
    "Universal Links is required on iOS. Please provide a valid universal links.",
    );
    return flutterPlatform.registerWechatApi(appId: appId, universalLink: universalLink);
  }

  Future<bool> isWechatInstalled() async {
    return flutterPlatform.isWechatInstalled();
  }

  Future<bool> isAlipayInstalled() async {
    return flutterPlatform.isAlipayInstalled();
  }

  Future<void> requestWechatPay(WechatPayReq req) async {
    flutterPlatform.requestWechatPay(req);
  }

  Future<void> requestAlipay(String payInfo) async {
    flutterPlatform.requestAlipay(payInfo);
  }

  Future<void> setAlipaySandboxEnv() async {
    assert(Platform.isAndroid, "Alipay sandbox environment is only available on Android.");
    flutterPlatform.setAlipaySandboxEnv();
  }

}
