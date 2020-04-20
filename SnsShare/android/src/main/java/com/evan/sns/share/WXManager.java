package com.evan.sns.share;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelmsg.SendAuth;

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
        mEntryActivity = entryActivity;
        mIWXAPI.handleIntent(intent, this);
    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp resp) {
      if (mHandler != null) {
          if (resp.getType() == ConstantsAPI.COMMAND_SENDAUTH) {
              //授权
              switch (resp.errCode) {
                  case BaseResp.ErrCode.ERR_AUTH_DENIED:
                      ///< 用户拒绝授权
                  case BaseResp.ErrCode.ERR_USER_CANCEL:
                      ///< 用户取消
                      String message = "取消了";
                      mHandler.onError(resp.errCode, message);
                      break;
                  case BaseResp.ErrCode.ERR_OK:
                      String code = ((SendAuth.Resp) resp).code;
                      mHandler.onSuccess(code);
                      break;
              }
          } else if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX
            || resp.getType() == ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX) {

              switch (resp.errCode) {
                  case BaseResp.ErrCode.ERR_OK:
                      mHandler.onSuccess("");
                      break;
                  default:
                      mHandler.onError(resp.errCode, resp.errStr);
                      break;
              }
          }

          mHandler = null;
        }

        if (mEntryActivity != null) {
            mEntryActivity.finish();
            mEntryActivity = null;
        }
    }
}
