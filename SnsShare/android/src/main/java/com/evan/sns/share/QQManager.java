package com.evan.sns.share;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.tencent.connect.common.Constants;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

import org.json.JSONException;
import org.json.JSONObject;

public class QQManager {
    private Tencent mTencent;
    private ResultListener mListener;
    private AsyncWorkHandler mLoginHandler;
    private AsyncWorkHandler mShareHandler;

    private static class SingletonClassInstance{
        private static final QQManager instance = new QQManager();
    }

    private QQManager(){
        this.mListener = new ResultListener();
    }

    public static QQManager getInstance(){
        return QQManager.SingletonClassInstance.instance;
    }

    public void registerApp(Context context, String appId) {
        mTencent = Tencent.createInstance(appId, context);
    }

    public void authorize(Activity activity, AsyncWorkHandler handler) {
        mTencent.loginServerSide(activity, "all", mListener);
        mLoginHandler = handler;
    }

    public void shareMessage(Activity activity, Bundle params, AsyncWorkHandler handler) {
        mTencent.shareToQQ(activity, params, mListener);
        mShareHandler = handler;
    }

    public void doResultIntent(int requestCode, int resultCode, Intent data) {

        if (requestCode == Constants.REQUEST_LOGIN ||
                requestCode == Constants.REQUEST_APPBAR ||
                requestCode == Constants.REQUEST_QQ_SHARE) {
            Tencent.onActivityResultData(requestCode, resultCode, data, mListener);
        }
    }

    private class ResultListener implements IUiListener {
        @Override
        public void onComplete(Object response) {
            if (mLoginHandler != null) {
                if (null == response) {
                    mLoginHandler.onError(-100, "登录失败");
                    mLoginHandler = null;
                    return;
                }
                JSONObject jsonResponse = (JSONObject) response;
                try {
                    String openId = jsonResponse.getString(Constants.PARAM_OPEN_ID);
                    String accessToken = jsonResponse.getString(Constants.PARAM_ACCESS_TOKEN);
                    String expiresIn = jsonResponse.getString(Constants.PARAM_EXPIRES_IN);

                    StringBuilder result = new StringBuilder();
                    result.append("open_id=");
                    result.append(openId);
                    result.append("accessToken=");
                    result.append(accessToken);
                    result.append("expiration_date=");
                    result.append(accessToken);

                    mLoginHandler.onSuccess(result.toString());
                    mLoginHandler = null;

                } catch (JSONException e) {
                    mLoginHandler.onError(-100, "登录失败");
                    mLoginHandler = null;
                }
            } else if (mShareHandler != null){
                mShareHandler.onSuccess("");
                mShareHandler = null;
            }
        }

        @Override
        public void onError(UiError e) {
            if (mLoginHandler != null) {
                mLoginHandler.onError(e.errorCode, e.errorMessage);
                mLoginHandler = null;
            } else if (mShareHandler != null) {
                mShareHandler.onError(e.errorCode, e.errorMessage);
                mShareHandler = null;
            }
        }

        @Override
        public void onCancel() {
            if (mLoginHandler != null) {
                mLoginHandler.onError(-1, "用户取消");
                mLoginHandler = null;
            } else if (mShareHandler != null) {
                mShareHandler.onError(-1, "用户取消");
                mShareHandler = null;
            }
        }
    }
}
