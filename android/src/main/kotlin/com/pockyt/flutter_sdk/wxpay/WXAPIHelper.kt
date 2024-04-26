package com.pockyt.flutter_sdk.wxpay

import android.content.Context
import android.content.Intent
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler
import com.tencent.mm.opensdk.openapi.WXAPIFactory

object WXAPIHelper {
    private var wxApi: IWXAPI? = null

    fun registerAPI(context: Context, appId: String): Boolean {
        wxApi = WXAPIFactory.createWXAPI(context.applicationContext, appId)
        return wxApi?.registerApp(appId) == true
    }

    fun isAppInstalled(): Boolean {
        return wxApi?.isWXAppInstalled == true
    }

    fun handleIntent(intent: Intent, eventHandler: IWXAPIEventHandler?) {
        wxApi?.handleIntent(intent, eventHandler)
    }

    fun requestPay(request: BaseReq): Boolean? {
        return wxApi?.sendReq(request)
    }

}
