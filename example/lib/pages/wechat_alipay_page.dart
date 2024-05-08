import 'dart:convert';
import 'dart:math';
import 'package:flutter_sdk_example/api/api_helper.dart';
import 'package:flutter_sdk_example/api/api_config.dart';
import 'package:flutter/material.dart';
import 'package:pockyt_pay/pockyt_pay.dart';

class WechatAliPayPage extends StatefulWidget {
  const WechatAliPayPage({super.key});

  @override
  _WechatAliPayPageState createState() => _WechatAliPayPageState();
}

class _WechatAliPayPageState extends State<WechatAliPayPage> {
  late TextEditingController _merchantNoController;
  late TextEditingController _storeNoController;
  late TextEditingController _amountController;

  final PockytPay pockyt = PockytPay();
  final StringBuffer showResultBuffer = StringBuffer();
  bool isWXInstalled = false;
  int logIndex = 0;

  @override
  void initState() {
    super.initState();
    _merchantNoController = TextEditingController(text: merchantNo);
    _storeNoController = TextEditingController(text: storeNo);
    _amountController = TextEditingController(text: "0.01");
    initWechatSDK();
    subscribeRespEvent();
  }

  void initWechatSDK() async {
    await pockyt.registerWechatApi(appId: wechatAppId, universalLink: universalLink);
    isWXInstalled = await pockyt.isWechatInstalled();
    bool isAlipayInstalled = await pockyt.isAlipayInstalled();
    showResultBuffer.writeln("${++logIndex}.isWechatInstalled: $isWXInstalled");
    showResultBuffer.writeln("${++logIndex}.isAlipayInstalled: $isAlipayInstalled");
    setState(() {
    });
  }

  void subscribeRespEvent() {
    pockyt.subscribe<BaseResp>((resp) {
      if (resp is WechatPayResp) {
        // Wechat Pay result
        showResultBuffer.writeln("${++logIndex}.paid:${resp.isSuccessful}"
            ", cancelled:${resp.isCancelled}, result:$resp");
      } else if (resp is AlipayResp) {
        // Alipay result
        showResultBuffer.writeln("${++logIndex}.paid:${resp.isSuccessful}"
            ", cancelled:${resp.isCancelled}, result:$resp");
      }
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _merchantNoController.dispose();
    _storeNoController.dispose();
    _amountController.dispose();
    pockyt.unsubscribe();
    super.dispose();
  }

  Future<void> _sendPostAndWechatPayRequest() async {
    final req = await _sendWechatPostRequest();
    if (req != null) {
      _sendWechatPayRequest(req);
    } else {
      setState(() {
      });
    }
  }

  Future<WechatPayReq?> _sendWechatPostRequest() async {
    String merchantNo = _merchantNoController.text;
    String storeNo = _storeNoController.text;
    String amount = _amountController.text;
    String reqUrl = "$baseUrl/micropay/v3/prepay";
    String reqJson = json.encode({
      'merchantNo': merchantNo,
      'storeNo': storeNo,
      'token': apiToken,
      'amount': amount,
      'vendor': 'wechatpay',
      'ipnUrl': 'https://merchant.com/ipn',
      'reference': 'REF-${Random().nextInt(999999).toString().padLeft(6, '0')}',
      'note': 'note',
      'description': 'description',
      'settleCurrency': 'USD',
      'currency': 'USD',
      'terminal': 'APP',
    });
    String resultStr = await APIHelper.doPost(reqUrl, reqJson);
    final resultJson = json.decode(resultStr);
    bool success = resultJson['ret_code'] == "000100";
    WechatPayReq? req =  success ? WechatPayReq.fromJson(resultJson['result']) : null;
    if (!success) showResultBuffer.writeln("${++logIndex}.$resultStr");
    return req;
  }

  void _sendWechatPayRequest(WechatPayReq req) async {
    pockyt.requestWechatPay(req);
  }

  Future<void> _sendPostAndAlipayRequest() async {
    final payInfo = await _sendAlipayPostRequest();
    if (payInfo.isNotEmpty) {
      _sendAlipayRequest(payInfo);
    } else {
      setState(() {
      });
    }
  }

  Future<String> _sendAlipayPostRequest() async {
    String merchantNo = _merchantNoController.text;
    String storeNo = _storeNoController.text;
    String amount = _amountController.text;
    String reqUrl = "$baseUrl/micropay/v3/prepay";
    String reqJson = json.encode({
      'merchantNo': merchantNo,
      'storeNo': storeNo,
      'token': apiToken,
      'amount': amount,
      'vendor': 'alipay',
      'ipnUrl': 'https://merchant.com/ipn',
      'reference': 'REF-${Random().nextInt(999999).toString().padLeft(6, '0')}',
      'note': 'note',
      'description': 'description',
      'settleCurrency': 'USD',
      'currency': 'USD',
      'terminal': 'APP',
    });
    String resultStr = await APIHelper.doPost(reqUrl, reqJson);
    final resultJson = json.decode(resultStr);
    bool success = resultJson['ret_code'] == "000100";
    String payInfo = success ? resultJson['result']['payInfo'] : '';
    if (!success) showResultBuffer.writeln("${++logIndex}.$resultStr");
    return payInfo;
  }

  void _sendAlipayRequest(String payInfo) async {
    pockyt.requestAlipay(payInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wechat Pay & Alipay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _merchantNoController,
              decoration: const InputDecoration(
                labelText: 'Merchant No',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _storeNoController,
              decoration: const InputDecoration(
                labelText: 'Store No',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 10.0),
            OutlinedButton(
              onPressed: isWXInstalled ? _sendPostAndWechatPayRequest : null,
              child: const Text('Send Request & Wechat Pay'),
            ),
            const SizedBox(height: 10.0),
            OutlinedButton(
              onPressed: _sendPostAndAlipayRequest,
              child: const Text('Send Request & Alipay'),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(showResultBuffer.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
