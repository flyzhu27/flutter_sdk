package com.pockyt.flutter_sdk.alipay

import android.app.Activity
import android.os.AsyncTask
import com.alipay.sdk.app.PayTask
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference

class AlipayAsyncTask(
    private val activity: Activity,
    private val channel: MethodChannel
) : AsyncTask<String, String, Map<String, String>>() {

    private val activityRef: WeakReference<Activity> = WeakReference(activity)
    private val channelRef: WeakReference<MethodChannel> = WeakReference(channel)

    override fun doInBackground(vararg params: String): Map<String, String>? {
        val activity = activityRef.get()
        if (activity != null && !activity.isFinishing) {
            val task = PayTask(activity)
            return task.payV2(params[0], true)
        }
        return null
    }

    override fun onPostExecute(result: Map<String, String>?) {
        if (result != null) {
            val activity = activityRef.get()
            val channel = channelRef.get()
            if (activity != null && !activity.isFinishing && channel != null) {
                channel.invokeMethod("onAlipayResp", result)
            }
        }
    }
}
