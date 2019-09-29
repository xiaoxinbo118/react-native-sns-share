package com.evan.sns.share;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

public class RNSnsPaymentModule extends ReactContextBaseJavaModule {
    private final ReactApplicationContext reactContext;

    public RNSnsPaymentModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void pay(int payType,
                      ReadableMap params,
                      Promise promise) {

        final Promise fPomise = promise;
        PaymentManager.getInstance().pay(payType, params, getCurrentActivity(), new AsyncWorkHandler() {
            @Override
            public void onSuccess() {
                fPomise.resolve(true);
            }

            @Override
            public void onError(int code, String message) {
                fPomise.reject(code + "", message);
            }
        });
    }

    @Override
    public String getName() {
        return "RNSnsPayment";
    }
}
