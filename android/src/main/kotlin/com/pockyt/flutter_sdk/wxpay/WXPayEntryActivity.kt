package com.pockyt.flutter_sdk.wxpay

import android.app.Activity
import android.content.Intent
import android.os.Bundle

class WXPayEntryActivity: Activity() {

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startFlutterActivity(intent)
        finish()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        startFlutterActivity(intent)
        finish()
    }

    private fun startFlutterActivity(intent: Intent?) {
        packageManager.getLaunchIntentForPackage(packageName)?.also {
            it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            it.putExtra(FLAG_PAYLOAD_FROM_WECHAT, true)
            it.putExtra(EXTRA_WECHAT_DATA, intent)
            try {
                startActivity(it)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    companion object {
        const val EXTRA_WECHAT_DATA = "EXTRA_WECHAT_DATA"
        const val FLAG_PAYLOAD_FROM_WECHAT = "FLAG_PAYLOAD_FROM_WECHAT"

        fun readWeChatCallbackIntent(intent: Intent?): Intent? {
            return if (intent?.getBooleanExtra(FLAG_PAYLOAD_FROM_WECHAT, false) == true) {
                intent.getParcelableExtra(EXTRA_WECHAT_DATA)
            } else {
                null
            }
        }
    }
}