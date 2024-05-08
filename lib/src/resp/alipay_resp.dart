import 'package:pockyt_pay/src/resp/base_resp.dart';

class AlipayResp extends BaseResp {
  /// Success, generally should be based on the asynchronous notifications or query results received by the server.
  static const String errorCodeSuccess = "9000";

  /// Order processing, please wait
  static const String errorCodePending = "8000";

  /// Failure, generally due to the user's payment failure
  static const String errorCodePayFail = "4000";

  /// Duplicate request
  static const String errorCodeDuplicateRequest = "5000";

  /// User cancels payment
  static const String errorCodeUserCancel = "6001";

  /// Network error
  static const String errorCodeNoConnection = "6002";

  final String? memo;

  AlipayResp({
    required super.respCode,
    super.respMsg,
    this.memo,
  });

  factory AlipayResp.fromJson(Map<String, dynamic> json) {
    return AlipayResp(
      respCode: json['resultStatus'],
      respMsg: json['result'],
      memo: json['memo'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'respCode': respCode,
      'respMsg': respMsg,
      'memo': memo,
    };
  }

  bool get isSuccessful => respCode == errorCodeSuccess;

  bool get isCancelled => respCode == errorCodeUserCancel;
}
