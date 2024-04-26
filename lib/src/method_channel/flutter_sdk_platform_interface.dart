import 'package:pockyt_pay/src/req/wechat_pay_req.dart';
import 'package:pockyt_pay/src/resp/base_resp.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_sdk_method_channel.dart';

abstract class FlutterSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterSdkPlatform.
  FlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSdkPlatform _instance = MethodChannelFlutterSdk();

  /// The default instance of [FlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSdk].
  static FlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<BaseResp> get responseEventHandler {
    throw UnimplementedError('responseEventHandler has not been implemented.');
  }

  Future<bool> registerWechatApi({
    required String appId,
    String? universalLink,
  }) async {
    throw UnimplementedError('registerWechatApi() has not been implemented.');
  }

  Future<bool> isWechatInstalled() async {
    throw UnimplementedError('isWechatInstalled() has not been implemented.');
  }

  Future<bool> isAlipayInstalled() async {
    throw UnimplementedError('isAlipayInstalled() has not been implemented.');
  }

  Future<void> requestWechatPay(WechatPayReq req) {
    throw UnimplementedError('requestWechatPay() has not been implemented.');
  }

  Future<void> requestAlipay(String payInfo) {
    throw UnimplementedError('requestAliPay() has not been implemented.');
  }

  Future<void> setAlipaySandboxEnv() {
    throw UnimplementedError('setAlipaySandboxEnv() has not been implemented.');
  }

}
