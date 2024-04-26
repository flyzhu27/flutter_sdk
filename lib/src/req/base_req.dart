import 'dart:convert';

abstract class BaseReq {
  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
