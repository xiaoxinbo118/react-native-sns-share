package com.evan.sns.share;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

public class RNSnsOAuthModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNSnsOAuthModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void auth(int authType,
                    ReadableMap params,
                    Promise promise) {

        final Promise fPomise = promise;
        OAuthManager.getInstance().auth(authType, params, getCurrentActivity(), new AsyncWorkHandler() {
            @Override
            public void onSuccess(String result) {
                fPomise.resolve(result);
            }

            @Override
            public void onError(int code, String message) {
                fPomise.reject(code + "", message);
            }
        });
    }

    @Override
    public String getName() {
        return "RNSnsOAuth";
    }
}
