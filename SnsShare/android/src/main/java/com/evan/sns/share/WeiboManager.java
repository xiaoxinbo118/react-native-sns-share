package com.evan.sns.share;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.sina.weibo.sdk.WbSdk;
import com.sina.weibo.sdk.api.WeiboMultiMessage;
import com.sina.weibo.sdk.auth.AuthInfo;
import com.sina.weibo.sdk.auth.Oauth2AccessToken;
import com.sina.weibo.sdk.auth.WbAuthListener;
import com.sina.weibo.sdk.auth.WbConnectErrorMessage;
import com.sina.weibo.sdk.auth.sso.SsoHandler;
import com.sina.weibo.sdk.share.WbShareCallback;
import com.sina.weibo.sdk.share.WbShareHandler;

public class WeiboManager {
    private SsoHandler mSsoHandler;
    private AsyncWorkHandler mSsoResultHandler;
    private WbShareHandler mShareHandler;
    private AsyncWorkHandler mShareResultHandler;

    public static final String SCOPE =
            "email,direct_messages_read,direct_messages_write,"
                    + "friendships_groups_read,friendships_groups_write,statuses_to_me_read,"
                    + "follow_app_official_microblog," + "invitation_write";

    private static class SingletonClassInstance{
        private static final WeiboManager instance = new WeiboManager();
    }

    private WeiboManager(){}

    public static WeiboManager getInstance(){
        return WeiboManager.SingletonClassInstance.instance;
    }


    public void registerApp(Context context, String appId, String redirectUrl) {
        WbSdk.install(context, new AuthInfo(context, appId, redirectUrl, WeiboManager.SCOPE));
    }

    public void shareMessage(Activity activity, WeiboMultiMessage message, AsyncWorkHandler handler) {

        mShareHandler = new WbShareHandler(activity);
        mShareHandler.registerApp();

        mShareHandler.shareMessage(message, false);

        mShareResultHandler = handler;
    }

    public void authorize(Activity activity, AsyncWorkHandler handler) {
        mSsoHandler = new SsoHandler(activity);

        mSsoHandler.authorize(new WbSsoResult());
    }

    public void doResultIntent(int requestCode, int resultCode, Intent data) {
        if (mShareHandler != null) {
            mShareHandler.doResultIntent(data, new WbShareResult());
        }

        if (mSsoHandler != null) {
            mSsoHandler.authorizeCallBack(requestCode, resultCode, data);
        }
    }

    private class WbShareResult implements WbShareCallback {
        @Override
        public void onWbShareSuccess() {
            mShareResultHandler.onSuccess("");
            mShareResultHandler = null;
            mShareHandler = null;
        }

        @Override
        public void onWbShareCancel() {
            mShareResultHandler.onError(-1, "has canceled");
            mShareResultHandler = null;
            mShareHandler = null;
        }

        @Override
        public void onWbShareFail() {
            mShareResultHandler.onError(-2, "has failed");
            mShareResultHandler = null;
            mShareHandler = null;
        }
    }

    private class WbSsoResult implements WbAuthListener {
        @Override
        public void onSuccess(Oauth2AccessToken token) {
            StringBuilder result = new StringBuilder();
            result.append("user_id=");
            result.append(token.getUid());
            result.append("access_token=");
            result.append(token.getToken());
            result.append("expiration_date=");
            result.append(token.getExpiresTime());
            result.append("refresh_token=");
            result.append(token.getRefreshToken());
            mShareResultHandler.onSuccess("");
            mShareResultHandler = null;
            mShareHandler = null;
        }

        @Override
        public void cancel() {
            mShareResultHandler.onError(-1, "has canceled");
            mShareResultHandler = null;
            mShareHandler = null;
        }

        @Override
        public void onFailure(WbConnectErrorMessage errorMessage) {
            mShareResultHandler.onError( Integer.parseInt(errorMessage.getErrorCode()), "has failed");
            mShareResultHandler = null;
            mShareHandler = null;
        }
    }
}