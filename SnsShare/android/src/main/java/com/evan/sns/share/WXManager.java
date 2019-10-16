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
    private AsyncWorkHandler mHandler;
    private String mAppId;

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
        mAppId = appId;
    }

    public String getAppId() {
        return mAppId;
    }

    public void sendReq(BaseReq req, AsyncWorkHandler handler) {
        boolean result = mIWXAPI.sendReq(req);

        if (result == false) {
            handler.onError(BaseResp.ErrCode.ERR_COMM, "params is error or wx is not install");
            return;
        }

        mHandler = handler;
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
        if (mHandler != null) {
            switch (resp.errCode) {
                case BaseResp.ErrCode.ERR_OK: {
                    mHandler.onSuccess("");
                }
                break;
                default:
                    mHandler.onError(resp.errCode, resp.errStr);
                    break;
            }
            mHandler = null;
        }

        if (mEntryActivity != null) {
            mEntryActivity.finish();
            mEntryActivity = null;
        }
    }
}
