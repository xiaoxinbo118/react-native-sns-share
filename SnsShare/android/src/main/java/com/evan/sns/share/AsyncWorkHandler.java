package com.evan.sns.share;

public interface AsyncWorkHandler {
    public void onSuccess();
    public void onError(int code, String message);
}
