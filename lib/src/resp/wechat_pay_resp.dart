import 'package:pockyt_pay/src/resp/base_resp.dart';

class WechatPayResp extends BaseResp {
  /// Success, generally should be based on the asynchronous notifications or query results received by the server.
  static const int errorCodeSuccess = 0;

  /// Possible reasons: signature error, unregistered APPID, incorrect APPID settings in the project, mismatch between registered APPID and the one set, and other exceptions.
  static const int errorCodeCommon = -1;

  /// User cancels payment
  static const int errorCodeUserCancel = -2;

  /// Failed to send
  static const int errorCodeSentFail = -3;

  /// Authorization failed
  static const int errorCodeAuthDeny = -4;

  /// WeChat does not support
  static const int errorCodeUnSupport = -5;

  WechatPayResp({
    required super.respCode,
    super.respMsg,
  });

  factory WechatPayResp.fromJson(Map<String, dynamic> json) {
    return WechatPayResp(
      respCode: "${json['errCode']}",
      respMsg: json['errStr'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'respCode': respCode,
      'respMsg': respMsg,
    };
  }

  bool get isSuccessful => respCode == errorCodeSuccess.toString();

  bool get isCancelled => respCode == errorCodeUserCancel.toString();
}
