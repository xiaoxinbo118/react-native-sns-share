package com.evan.sns.share;

public interface AsyncWorkHandler {
    public void onSuccess(String result);
    public void onError(int code, String message);
}
