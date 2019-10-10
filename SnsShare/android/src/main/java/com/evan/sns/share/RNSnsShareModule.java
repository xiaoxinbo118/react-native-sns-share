
package com.evan.sns.share;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


public class RNSnsShareModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNSnsShareModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @ReactMethod
  public void share(int shareType,
                    String webpageUrl,
                    String title,
                    String description,
                    String imageUrl,
                    Promise promise) {
    ShareEntity entity = new ShareEntity();
    entity.setWebPageUrl(webpageUrl);
    entity.setTitle(title);
    entity.setDesc(description);
    entity.setThumb(imageUrl);
    entity.setType(shareType);
    final Promise fPomise = promise;
    ShareManager.getInstance().share(entity, getCurrentActivity(), new AsyncWorkHandler() {
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
    return "RNSnsShare";
  }
}
