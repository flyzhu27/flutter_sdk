import 'base_req.dart';

class WechatPayReq extends BaseReq {

  final String appId;
  final String partnerId;
  final String prepayId;
  final String nonceStr;
  final String timeStamp;
  final String packageValue;
  final String sign;

  WechatPayReq({
    required this.appId,
    required this.partnerId,
    required this.prepayId,
    required this.nonceStr,
    required this.timeStamp,
    required this.packageValue,
    required this.sign,
  });

  factory WechatPayReq.fromJson(Map<String, dynamic> json) {
    return WechatPayReq(
      appId: json['appid'],
      partnerId: json['partnerid'],
      prepayId: json['prepayid'],
      nonceStr: json['noncestr'],
      timeStamp: json['timestamp'],
      packageValue: json['package'],
      sign: json['sign'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'appid': appId,
      'partnerid': partnerId,
      'prepayid': prepayId,
      'noncestr': nonceStr,
      'timestamp': timeStamp,
      'package': packageValue,
      'sign': sign,
    };
  }
}