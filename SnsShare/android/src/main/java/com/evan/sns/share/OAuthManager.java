package com.evan.sns.share;

import android.app.Activity;
import android.text.TextUtils;

import com.alipay.sdk.app.AuthTask;
import com.facebook.react.bridge.ReadableMap;
import com.tencent.mm.opensdk.modelmsg.SendAuth;

public class OAuthManager {
    public interface AuthType {
        int weChat = 0;
        int alipay = 1;
        int qq = 2;
        int weibo = 3;
    }

    private static class SingletonClassInstance{
        private static final OAuthManager instance = new OAuthManager();
    }

    private OAuthManager(){}

    public static OAuthManager getInstance(){
        return OAuthManager.SingletonClassInstance.instance;
    }

    public void auth(int type, ReadableMap params, Activity activity, AsyncWorkHandler handler) {
        if (type == OAuthManager.AuthType.weChat) {
            this.authWX(params, handler);
        } else if (type == OAuthManager.AuthType.alipay) {
            this.authAli(params, activity, handler);
        } else if (type == AuthType.weibo) {
            this.authWeibo(activity, handler);
        } else if (type == AuthType.qq) {
            this.authQQ(activity, handler);
        }
    }

    public void authWX(ReadableMap params, AsyncWorkHandler handler) {
        final SendAuth.Req request = new SendAuth.Req();
        request.scope = "snsapi_userinfo";
        request.state = "wechat.oauth";

        //发起请求
        WXManager.getInstance().sendReq(request, handler);
    }

    public void authWeibo(Activity activity, AsyncWorkHandler handler) {
        WeiboManager.getInstance().authorize(activity, handler);
    }

    public void authQQ(Activity activity, AsyncWorkHandler handler) {
        QQManager.getInstance().authorize(activity, handler);
    }

    public void authAli(ReadableMap params, final Activity activity, final AsyncWorkHandler handler) {
        final String authSign = params.getString("authLink");

        Runnable authRunnable = new Runnable() {
            @Override
            public void run() {

                // 构造AuthTask 对象
                AuthTask authTask = new AuthTask(activity);

                // 调用授权接口，获取授权结果
                String rawResult = authTask.auth(authSign,true);

                /*需要解析的参数*/
                String resultStatus = null;
                String result   = null;
                String resultCode = null;
                String authCode = null;

                String[] resultParams = rawResult.split(";");
                for (String resultParam : resultParams) {
                    if (resultParam.startsWith("resultStatus")) {
                        resultStatus = getResultParam(resultParam, "resultStatus");
                    }
                    if (resultParam.startsWith("result")) {
                        result = getResultParam(resultParam, "result");
                    }
                }

                String[] resultValue = result.split("&");
                for (String value : resultValue) {
//                            if (value.startsWith("alipay_open_id")) {
//                                alipayOpenId = getValue(value);
//                            }
                    if (value.startsWith("auth_code")) {
                        authCode = getValue(value);
                    }
                    if (value.startsWith("result_code")) {
                        resultCode = getValue(value);
                    }
                }



                // 判断resultStatus 为“9000”且result_code 为“200”则代表授权成功，具体状态码代表含义可参考授权接口文档
                if (TextUtils.equals(resultStatus, "9000") && TextUtils.equals(resultCode, "200")) {
                    // 获取alipay_open_id，调支付时作为参数extern_token 的value 传入，则用户使用的支付账户为该授权账户
                } else {
                    // 其他状态值则为授权失败
                    String errmsg = "用户取消授权";
                    if (TextUtils.equals(resultStatus, "4000")) {
                        errmsg = "系统异常";
                    }
                    else if (TextUtils.equals(resultStatus, "6001")) {
                        errmsg = "用户中途取消";
                    }
                    else if (TextUtils.equals(resultStatus, "6002")) {
                        errmsg = "网络连接出错";
                    }
                    else {
                        if (TextUtils.equals(resultCode, "1005")) {
                            errmsg = "账户已冻结,如有疑问,请联系支付宝技术支持";
                        }
                        else if (TextUtils.equals(resultCode, "713")) {
                            errmsg = "userId 不能转换为 openId,请联系支付宝技术支持";
                        }
                        else if (TextUtils.equals(resultCode, "202")) {
                            errmsg = "系统异常,请联系支付宝技术支持";
                        }
                    }

                    //最后异常抛出即可
                    handler.onError(Integer.parseInt(resultStatus), errmsg);
                }

                handler.onSuccess(authCode);
            }
        };

        // 必须异步调用
        Thread payThread = new Thread(authRunnable);
        payThread.start();
    }

    private String getResultParam(String content, String key) {
        String prefix = key + "={";
        return content.substring(content.indexOf(prefix) + prefix.length(),
                content.lastIndexOf("}"));
    }

    private String getValue(String data) {
        String[] content = data.split("=\"");
        String value = content[1];
        return value.substring(0, value.lastIndexOf("\""));
    }
}
