import 'dart:convert';

abstract class BaseResp {

  final String respCode;
  final String? respMsg;

  const BaseResp({
    required this.respCode,
    this.respMsg,
  });

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}