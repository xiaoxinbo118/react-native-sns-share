package com.evan.sns.share;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.sina.weibo.sdk.WbSdk;
import com.sina.weibo.sdk.api.WeiboMultiMessage;
import com.sina.weibo.sdk.auth.AuthInfo;
import com.sina.weibo.sdk.share.WbShareCallback;
import com.sina.weibo.sdk.share.WbShareHandler;

public class WeiboManager {
    private WbShareHandler mShareHandler;
    private AsyncWorkHandler mHandler;

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


    public void registerApp(Context context, String appId) {
        WbSdk.install(context, new AuthInfo(context, appId, "https://m.baidu.com", WeiboManager.SCOPE));
    }

    public void shareMessage(Activity activity, WeiboMultiMessage message, AsyncWorkHandler handler) {

        mShareHandler = new WbShareHandler(activity);
        mShareHandler.registerApp();

        mShareHandler.shareMessage(message, false);

        mHandler = handler;
    }

    public void doResultIntent(Intent data) {
        if (mShareHandler != null) {
            mShareHandler.doResultIntent(data, new WbShareResult());
        }
    }

    private class WbShareResult implements WbShareCallback {
        @Override
        public void onWbShareSuccess() {
            mHandler.onSuccess();
            mHandler = null;
            mShareHandler = null;
        }

        @Override
        public void onWbShareCancel() {
            mHandler.onError(-1, "has canceled");
            mHandler = null;
            mShareHandler = null;
        }

        @Override
        public void onWbShareFail() {
            mHandler.onError(-2, "has failed");
            mHandler = null;
            mShareHandler = null;
        }
    }
}