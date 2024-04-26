import 'package:flutter_test/flutter_test.dart';
import 'package:pockyt_pay/src/method_channel/flutter_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pockyt_pay/src/method_channel/flutter_sdk_platform_interface.dart';
import 'package:pockyt_pay/src/req/wechat_pay_req.dart';
import 'package:pockyt_pay/src/resp/base_resp.dart';

class MockFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterSdkPlatform {

  @override
  Future<bool> isAlipayInstalled() {
    // TODO: implement isAlipayInstalled
    throw UnimplementedError();
  }

  @override
  Future<bool> isWechatInstalled() {
    // TODO: implement isWechatInstalled
    throw UnimplementedError();
  }

  @override
  Future<bool> registerWechatApi({required String appId, String? universalLink}) {
    // TODO: implement registerWechatApi
    throw UnimplementedError();
  }

  @override
  Future<void> requestAlipay(String payInfo) {
    // TODO: implement requestAlipay
    throw UnimplementedError();
  }

  @override
  Future<void> requestWechatPay(WechatPayReq req) {
    // TODO: implement requestWechatPay
    throw UnimplementedError();
  }

  @override
  // TODO: implement responseEventHandler
  Stream<BaseResp> get responseEventHandler => throw UnimplementedError();

  @override
  Future<void> setAlipaySandboxEnv() {
    // TODO: implement setAlipaySandboxEnv
    throw UnimplementedError();
  }
}

void main() {
  final FlutterSdkPlatform initialPlatform = FlutterSdkPlatform.instance;

  test('$MethodChannelFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSdk>());
  });

}
