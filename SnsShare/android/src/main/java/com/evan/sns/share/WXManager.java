package com.evan.sns.share;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class WXManager implements IWXAPIEventHandler {
    protected IWXAPI mIWXAPI;
    private Activity mEntryActivity;
    private AsyncWorkHandler mHander;

    private static class SingletonClassInstance{
        private static final WXManager instance = new WXManager();
    }

    private WXManager(){}

    public static WXManager getInstance(){
        return SingletonClassInstance.instance;
    }

    public void registerApp(Context context, String appId) {
        mIWXAPI = WXAPIFactory.createWXAPI(context, appId);
        mIWXAPI.registerApp(appId);
    }

    public void sendReq(BaseReq req, AsyncWorkHandler hander) {
        boolean result = mIWXAPI.sendReq(req);

        if (result == false) {
            hander.onError(BaseResp.ErrCode.ERR_COMM, "参数错误");
            return;
        }

        mHander = hander;
    }

    public void handleIntent(Intent intent, Activity entryActivity) {
        mIWXAPI.handleIntent(intent, this);
        mEntryActivity = entryActivity;
    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp resp) {
        if (mHander != null) {
            switch (resp.errCode) {
                case BaseResp.ErrCode.ERR_OK: {
                    mHander.onSuccess();
                }
                break;
                default:
                    mHander.onError(resp.errCode, resp.errStr);
                    break;
            }
        }

        if (mEntryActivity != null) {
            mEntryActivity.finish();
            mEntryActivity = null;
        }
    }
}
