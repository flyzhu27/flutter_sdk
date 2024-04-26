import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class APIHelper {
  static Future<String> doPost(String reqUrl, String reqJson) async {
    HttpClient httpClient = HttpClient();
    try {
      final request = await httpClient.postUrl(Uri.parse(reqUrl))
        ..headers.set('content-type', 'application/json');
      final reqMap = jsonDecode(reqJson) as Map<String, dynamic>;
      final token = reqMap.remove('token');
      reqMap['verifySign'] = _calcVerifySign(reqMap, token);
      request.add(utf8.encode(json.encode(reqMap)));
      final response = await request.close();
      final responseBody = await utf8.decodeStream(response);
      httpClient.close();
      return responseBody;
    } catch (e) {
      return 'Request resp error: $e';
    }
  }

  static String _calcVerifySign(Map<String, dynamic> reqMap, String token) {
    final keyArrays = reqMap.keys.toList()..sort();
    final psb = StringBuffer();
    for (final key in keyArrays) {
      final value = reqMap[key];
      if (value != null) {
        psb.write('$key=$value&');
      }
    }
    psb.write(md5.convert(utf8.encode(token)).toString());
    return md5.convert(utf8.encode(psb.toString())).toString();
  }
}
