## Introduction

`pockyt_pay` is a flutter plugin for Wechat Pay and Alipay.

## Getting Started

- Register on the WeChat Open Platform, complete developer authentication, create an application, and obtain the appID.
- For iOS, configure the universal link in the WeChat Open Platform. [official document](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html)
- For Android, configure the package name and signature in the WeChat Open Platform. [official signature apk](https://res.wx.qq.com/wxdoc/dist/assets/media/Gen_Signature_Android.e481f889.zip)

## Configuration

* Configure the plugin in the `pubspec.yaml` file.
```yaml
dependencies:
  pockyt_pay: ^${lastest_version}
  
pockyt:
  app_id: ${wechat app id}
  url_scheme: ${alipay url scheme, unique string}
  ios:
    universal_link: ${wechat universal link}
```

* Install for iOS
```shell
# step.1 Install missing dependencies
sudo gem install plist

# step.2 Enter iOS folder(example/ios/,ios/)
cd example/ios/

# step.3 Execute
pod install
```

## How to use

* Only four steps are needed to complete the payment call
```dart
// Create a PockytPay instance
PockytPay pockyt = PockytPay();

// Subscribe to payment result events
pockyt.onSubscriber();

// Request Alipay or Wechat Pay
pockyt.requestAlipay();
pockyt.requestWechatPay();

// Cancel subscription
pockyt.offSubscriber();
```

* Please refer to the example for detailed usage instructions
  [example code](https://github.com/yuansfer/flutter_sdk/example/lib/main.dart)