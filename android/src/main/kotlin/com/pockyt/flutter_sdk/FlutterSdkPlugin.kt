package com.pockyt.flutter_sdk

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.AsyncTask
import android.os.AsyncTask.THREAD_POOL_EXECUTOR
import com.alipay.sdk.app.EnvUtils
import com.pockyt.flutter_sdk.alipay.AlipayAsyncTask
import com.pockyt.flutter_sdk.wxpay.WXAPIHelper
import com.pockyt.flutter_sdk.wxpay.WXPayEntryActivity
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class FlutterSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.NewIntentListener {

  private lateinit var channel : MethodChannel
  private var activityPluginBinding: ActivityPluginBinding? = null
  private lateinit var context: Context

  private val wxApiEventHandler = object : IWXAPIEventHandler {
    override fun onReq(p0: BaseReq?) {
    }

    override fun onResp(p0: BaseResp?) {
      val result = mapOf(
        "errCode" to p0?.errCode,
        "errStr" to p0?.errStr
      )
      channel.invokeMethod("onWechatPayResp", result)
    }
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pockyt.io/flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "registerWechatApi" -> {
        val appId = call.argument<String>("appId")
        appId?.let {
          result.success(WXAPIHelper.registerAPI(context, it))
        }
      }
      "isWechatInstalled" -> {
        result.success(WXAPIHelper.isAppInstalled())
      }
      "requestWechatPay" -> {
        val request = PayReq()
        request.appId = call.argument("appid")
        request.partnerId = call.argument("partnerid")
        request.prepayId = call.argument("prepayid")
        request.packageValue = call.argument("package")
        request.nonceStr = call.argument("noncestr")
        request.timeStamp = call.argument<Long>("timestamp").toString()
        request.sign = call.argument("sign")
        result.success(WXAPIHelper.requestPay(request))
      }
      "requestAlipay" -> {
        activityPluginBinding?.activity?.let {
          val asyncTask = AlipayAsyncTask(it, channel)
          if (asyncTask.status != AsyncTask.Status.RUNNING) {
            asyncTask.executeOnExecutor(THREAD_POOL_EXECUTOR, call.argument("payInfo"))
          }
        }
      }
      "setAlipaySandboxEnv" -> {
        EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX)
      }
      "isAlipayInstalled" -> {
        result.success(isAlipayInstalled())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
    activityPluginBinding?.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    activityPluginBinding = null
  }

  override fun onNewIntent(intent: Intent): Boolean {
    return WXPayEntryActivity.readWeChatCallbackIntent(intent)?.let {
        WXAPIHelper.handleIntent(it, wxApiEventHandler)
      true
    } ?: false
  }

  private fun isAlipayInstalled(): Boolean {
    val manager = activityPluginBinding?.activity?.packageManager
    return if (manager != null) {
      val action = Intent(Intent.ACTION_VIEW)
      action.data = Uri.parse("alipays://")
      val list = manager.queryIntentActivities(action, PackageManager.GET_RESOLVED_FILTER)
      list.isNotEmpty()
    } else {
      false
    }
  }

}
