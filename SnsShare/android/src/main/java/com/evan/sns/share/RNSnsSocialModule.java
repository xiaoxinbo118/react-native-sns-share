package com.evan.sns.share;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

public class RNSnsSocialModule extends ReactContextBaseJavaModule {
    private final ReactApplicationContext reactContext;

    public RNSnsSocialModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void registerApp(ReadableMap appIds, ReadableMap redirectUrls, String universalLink) {
        String wxAppId = appIds.getString("wechart");
        
        WXManager.getInstance().registerApp(getReactApplicationContext(), wxAppId);

        String wbAppId = appIds.getString("weibo");
        String redirectUrl = redirectUrls.getString("weibo");

        WeiboManager.getInstance().registerApp(getReactApplicationContext(), wbAppId, redirectUrl);
    }

    @Override
    public String getName() {
        return "RNSnsSocial";
    }
}
