
import 'package:flutter/material.dart';
import 'package:flutter_sdk_example/pages/alipay_pay_page.dart';
import 'package:flutter_sdk_example/pages/wechat_alipay_page.dart';
import 'pages/wechat_pay_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pockyt Payment Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          OutlinedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const WechatPayPage()));
          },
              child: const Text('Wechat Pay')),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AlipayPage()));
            },
            child: const Text('Alipay'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WechatAliPayPage()));
            },
            child: const Text('Wechat Pay & Alipay'),
          ),
        ],
      ),
    );
  }
}
