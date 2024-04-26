import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pockyt_pay/pockyt_pay.dart';
import 'flutter_sdk_platform_interface.dart';

class MethodChannelFlutterSdk extends FlutterSdkPlatform {

  @visibleForTesting
  late final methodChannel = const MethodChannel('pockyt.io/flutter')
                        ..setMethodCallHandler(_methodHandler);
  final StreamController<BaseResp> _respStreamController = StreamController<BaseResp>.broadcast();

  @override
  Stream<BaseResp> get responseEventHandler {
    return _respStreamController.stream;
  }

  Future<dynamic> _methodHandler(MethodCall call) {
    final Map<String, dynamic> result = (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>();
    switch(call.method) {
      case "onWechatPayResp":
        _respStreamController.add(WechatPayResp.fromJson(result));
        break;
      case "onAlipayResp":
        _respStreamController.add(AlipayResp.fromJson(result));
        break;
    }
    return Future.value();
  }

  @override
  Future<bool> registerWechatApi({required String appId, String? universalLink}) async {
    return await methodChannel.invokeMethod<bool>(
      'registerWechatApi',
      <String, dynamic>{
        'appId': appId,
        'universalLink': universalLink,
      },
    ) ?? false;
  }

  @override
  Future<bool> isWechatInstalled() async {
    return await methodChannel.invokeMethod<bool>('isWechatInstalled') ?? false;
  }

  @override
  Future<bool> isAlipayInstalled() async {
    return await methodChannel.invokeMethod<bool>('isAlipayInstalled') ?? false;
  }

  @override
  Future<void> requestWechatPay(WechatPayReq req) async {
    await methodChannel.invokeMethod<void>(
      'requestWechatPay',
      req.toJson(),
    );
  }

  @override
  Future<void> requestAlipay(String payInfo) async {
    await methodChannel.invokeMethod<void>(
      'requestAlipay',
      {"payInfo": payInfo},
    );
  }

  @override
  Future<void> setAlipaySandboxEnv() async {
    return methodChannel.invokeMethod<void>('setAlipaySandboxEnv');
  }
}
