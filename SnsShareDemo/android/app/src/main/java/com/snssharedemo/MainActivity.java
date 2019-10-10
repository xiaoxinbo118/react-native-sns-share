package com.snssharedemo;

import android.content.Intent;

import com.evan.sns.share.WXManager;
import com.evan.sns.share.WeiboManager;
import com.facebook.react.ReactActivity;

public class MainActivity extends ReactActivity {

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // 接收微博分享后的返回值
        WeiboManager.getInstance().doResultIntent(data);
    }

    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "SnsShareDemo";
    }
}
