import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pockyt_pay/pockyt_pay.dart';
import 'flutter_sdk_platform_interface.dart';

class MethodChannelFlutterSdk extends FlutterSdkPlatform {
  @visibleForTesting
  late final methodChannel = const MethodChannel('pockyt.io/flutter')
    ..setMethodCallHandler(_methodHandler);
  final StreamController<BaseResp> _respStreamController =
      StreamController<BaseResp>.broadcast();

  @override
  Stream<BaseResp> get responseEventHandler {
    return _respStreamController.stream;
  }

  /// Method handler for handling method calls from the platform side.
  ///
  /// This method is called when a method call is received from the platform side.
  /// It parses the method call arguments and triggers the appropriate response event.
  Future<dynamic> _methodHandler(MethodCall call) {
    final Map<String, dynamic> result =
        (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>();
    switch (call.method) {
      case "onWechatPayResp":
        _respStreamController.add(WechatPayResp.fromJson(result));
        break;
      case "onAlipayResp":
        _respStreamController.add(AlipayResp.fromJson(result));
        break;
    }
    return Future.value();
  }

  /// Registers the WeChat API with the provided app ID and universal link.
  ///
  /// Returns true if the WeChat API is successfully registered, false otherwise.
  @override
  Future<bool> registerWechatApi(
      {required String appId, String? universalLink}) async {
    return await methodChannel.invokeMethod<bool>(
          'registerWechatApi',
          <String, dynamic>{
            'appId': appId,
            'universalLink': universalLink,
          },
        ) ??
        false;
  }

  /// Checks if WeChat APP is installed on the device.
  ///
  /// Returns true if WeChat is installed, false otherwise.
  @override
  Future<bool> isWechatInstalled() async {
    return await methodChannel.invokeMethod<bool>('isWechatInstalled') ?? false;
  }

  /// Checks if Alipay APP is installed on the device.
  ///
  /// Returns true if Alipay is installed, false otherwise.
  @override
  Future<bool> isAlipayInstalled() async {
    return await methodChannel.invokeMethod<bool>('isAlipayInstalled') ?? false;
  }

  /// Requests WeChat Pay with the provided [req].
  ///
  /// Sends a request to the platform side to initiate a WeChat Pay transaction.
  @override
  Future<void> requestWechatPay(WechatPayReq req) async {
    await methodChannel.invokeMethod<void>(
      'requestWechatPay',
      req.toJson(),
    );
  }

  /// Requests Alipay with the provided [payInfo].
  ///
  /// Sends a request to the platform side to initiate an Alipay transaction using the provided [payInfo].
  @override
  Future<void> requestAlipay(String payInfo) async {
    await methodChannel.invokeMethod<void>(
      'requestAlipay',
      {"payInfo": payInfo},
    );
  }

  /// Sets the Alipay sandbox environment.
  /// This method can only be used on Android.
  /// Sends a request to the platform side to set the Alipay environment to sandbox for testing purposes.
  @override
  Future<void> setAlipaySandboxEnv() async {
    return methodChannel.invokeMethod<void>('setAlipaySandboxEnv');
  }
}
