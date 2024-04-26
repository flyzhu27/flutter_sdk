import 'dart:convert';
import 'dart:math';
import 'package:flutter_sdk_example/api/api_helper.dart';
import 'package:flutter_sdk_example/api/api_config.dart';
import 'package:flutter/material.dart';
import 'package:pockyt_pay/pockyt_pay.dart';

class AlipayPage extends StatefulWidget {
  const AlipayPage({super.key});

  @override
  _AlipayPageState createState() => _AlipayPageState();
}

class _AlipayPageState extends State<AlipayPage> {
  late TextEditingController _merchantNoController;
  late TextEditingController _storeNoController;
  late TextEditingController _amountController;

  final PockytPay pockyt = PockytPay();
  final StringBuffer showResultBuffer = StringBuffer();
  int logIndex = 0;

  @override
  void initState() {
    super.initState();
    _merchantNoController = TextEditingController(text: merchantNo);
    _storeNoController = TextEditingController(text: storeNo);
    _amountController = TextEditingController(text: "0.01");
    _checkAlipayInstalled();
    _subscribeRespEvent();
  }

  void _checkAlipayInstalled() {
    pockyt.isAlipayInstalled().then((value) {
      showResultBuffer.writeln("${++logIndex}.isAlipayInstalled: $value");
      setState(() {
      });
    });
  }

  void _subscribeRespEvent() {
    pockyt.onSubscriber<AlipayResp>((resp) {
      showResultBuffer.writeln("${++logIndex}.paid:${resp.isSuccessful}"
          ", cancelled:${resp.isCancelled}, result:$resp");
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _merchantNoController.dispose();
    _storeNoController.dispose();
    _amountController.dispose();
    pockyt.offSubscriber();
    super.dispose();
  }

  Future<void> _sendPostAndPayRequest() async {
    final payInfo = await _sendPostRequest();
    if (payInfo.isNotEmpty) {
      _sendPayRequest(payInfo);
    } else {
      setState(() {
      });
    }
  }

  Future<String> _sendPostRequest() async {
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

  void _sendPayRequest(String payInfo) async {
    pockyt.requestAlipay(payInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alipay'),
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
              onPressed: _sendPostAndPayRequest,
              child: const Text('Send Request & Pay'),
            ),
            const SizedBox(height: 16),
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
