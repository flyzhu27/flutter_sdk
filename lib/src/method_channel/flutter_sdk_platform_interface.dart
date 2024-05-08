import 'package:pockyt_pay/src/req/wechat_pay_req.dart';
import 'package:pockyt_pay/src/resp/base_resp.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_sdk_method_channel.dart';

abstract class FlutterSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterSdkPlatform.
  FlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  /// An abstract class representing the Flutter SDK platform.
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

  /// Returns a stream of [BaseResp] representing response events.
  Stream<BaseResp> get responseEventHandler {
    throw UnimplementedError('responseEventHandler has not been implemented.');
  }

  /// Registers the WeChat API.
  ///
  /// The [appId] parameter is the WeChat app ID.
  /// The [universalLink] parameter is the universal link for iOS (required on iOS).
  /// Returns a [Future] that completes with a boolean value indicating if the registration was successful.
  Future<bool> registerWechatApi({
    required String appId,
    String? universalLink,
  }) async {
    throw UnimplementedError('registerWechatApi() has not been implemented.');
  }

  /// Checks if WeChat APP is installed on the device.
  ///
  /// Returns a [Future] that completes with a boolean value indicating if WeChat is installed.
  Future<bool> isWechatInstalled() async {
    throw UnimplementedError('isWechatInstalled() has not been implemented.');
  }

  /// Checks if Alipay APP is installed on the device.
  ///
  /// Returns a [Future] that completes with a boolean value indicating if Alipay is installed.
  Future<bool> isAlipayInstalled() async {
    throw UnimplementedError('isAlipayInstalled() has not been implemented.');
  }

  /// Requests a WeChat payment.
  ///
  /// The [req] parameter is the WeChat payment request.
  Future<void> requestWechatPay(WechatPayReq req) {
    throw UnimplementedError('requestWechatPay() has not been implemented.');
  }

  /// Requests an Alipay payment.
  ///
  /// The [payInfo] parameter is the Alipay payment information.
  Future<void> requestAlipay(String payInfo) {
    throw UnimplementedError('requestAliPay() has not been implemented.');
  }

  /// Sets the Alipay sandbox environment.
  ///
  /// Throws an exception if the method is called on a non-Android platform.
  Future<void> setAlipaySandboxEnv() {
    throw UnimplementedError('setAlipaySandboxEnv() has not been implemented.');
  }
}
