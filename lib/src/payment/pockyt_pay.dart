import 'dart:async';
import 'dart:io';
import 'package:pockyt_pay/pockyt_pay.dart';
import 'package:pockyt_pay/src/method_channel/flutter_sdk_platform_interface.dart';

/// A class representing the PockytPay functionality.
class PockytPay {
  late StreamSubscription<BaseResp>? _subscription;
  final FlutterSdkPlatform flutterPlatform = FlutterSdkPlatform.instance;

  /// Subscribes to a specific type of response.
  ///
  /// The [onResponse] callback function will be called when a response of type [T] is received.
  void subscribe<T extends BaseResp>(void Function(T) onResponse) {
    _subscription = flutterPlatform.responseEventHandler
        .where((event) => event is T)
        .cast<T>()
        .listen(onResponse);
  }

  /// Unsubscribes from receiving response events.
  void unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
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
    assert(
      !Platform.isIOS || (universalLink?.isNotEmpty ?? false),
      "Universal Links is required on iOS. Please provide a valid universal links.",
    );
    return flutterPlatform.registerWechatApi(
        appId: appId, universalLink: universalLink);
  }

  /// Checks if WeChat APP is installed on the device.
  ///
  /// Returns a [Future] that completes with a boolean value indicating if WeChat is installed.
  Future<bool> isWechatInstalled() async {
    return flutterPlatform.isWechatInstalled();
  }

  /// Checks if Alipay APP is installed on the device.
  ///
  /// Returns a [Future] that completes with a boolean value indicating if Alipay is installed.
  Future<bool> isAlipayInstalled() async {
    return flutterPlatform.isAlipayInstalled();
  }

  /// Requests a WeChat payment.
  ///
  /// The [req] parameter is the WeChat payment request.
  Future<void> requestWechatPay(WechatPayReq req) async {
    flutterPlatform.requestWechatPay(req);
  }

  /// Requests an Alipay payment.
  ///
  /// The [payInfo] parameter is the Alipay payment information.
  Future<void> requestAlipay(String payInfo) async {
    flutterPlatform.requestAlipay(payInfo);
  }

  /// Sets the Alipay sandbox environment.
  ///
  /// This method can only be used on Android.
  Future<void> setAlipaySandboxEnv() async {
    assert(Platform.isAndroid,
        "Alipay sandbox environment is only available on Android.");
    flutterPlatform.setAlipaySandboxEnv();
  }
}
