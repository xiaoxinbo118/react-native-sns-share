package com.evan.sns.share;

import android.app.Activity;
import android.text.TextUtils;

import com.alipay.sdk.app.PayTask;
import com.facebook.react.bridge.ReadableMap;
import com.tencent.mm.opensdk.modelpay.PayReq;

import java.util.Map;

public class PaymentManager {
    public interface PaymentType {
        int weChat = 0;
        int alipay = 1;
    }

    private static class SingletonClassInstance{
        private static final PaymentManager instance = new PaymentManager();
    }

    private PaymentManager(){}

    public static PaymentManager getInstance(){
        return PaymentManager.SingletonClassInstance.instance;
    }

    public void pay(int type, ReadableMap params,  Activity activity, AsyncWorkHandler handler) {
        if (type == PaymentType.weChat) {
            this.payWX(params, handler);
        } else if (type == PaymentType.alipay) {
            this.payAli(params, activity, handler);
        }
    }

    public void payWX(ReadableMap params,  AsyncWorkHandler handler) {
        PayReq request = new PayReq();
        request.appId = WXManager.getInstance().getAppId();
        request.partnerId = params.getString("partnerId");
        request.prepayId = params.getString("prepayId");
        request.packageValue = params.getString("package");
        request.nonceStr = params.getString("nonceStr");
        request.timeStamp = params.getString("timeStamp");
        request.sign = params.getString("sign");

        WXManager.getInstance().sendReq(request, handler);
    }

    public void payAli(ReadableMap params,  final Activity activity, final AsyncWorkHandler handler) {
        final String orderInfo = params.getString("order");   // 订单信息

        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                PayTask alipay = new PayTask(activity);
                Map<String,String> result = alipay.payV2(orderInfo,true);
                PayResult payResult = new PayResult(result.toString());

                // 支付宝返回此次支付结果及加签，建议对支付宝签名信息拿签约时支付宝提供的公钥做验签
                String resultStatus = payResult.getResultStatus();

                // 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
                if (TextUtils.equals(resultStatus, "9000")) {
                    handler.onSuccess(resultStatus);
                } else {
                    if (resultStatus == null) resultStatus = "4000";
                    // 判断resultStatus 为非“9000”则代表可能支付失败
                    // “8000”代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
                    if (TextUtils.equals(resultStatus, "8000")) {
                        handler.onError(Integer.parseInt(resultStatus), "system busy");
                    } else {
                        // 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
                        String value = TextUtils.isEmpty(resultStatus) ? "0" : resultStatus;
                        handler.onError(Integer.parseInt(resultStatus), "pay failed");
                    }
                }
            }
        };
        // 必须异步调用
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }

    private class PayResult {
        private String resultStatus;
        private String result;
        private String memo;

        public PayResult(String rawResult) {

            if (TextUtils.isEmpty(rawResult))
                return;

            String[] resultParams = rawResult.split(";");
            for (String resultParam : resultParams) {
                if (resultParam.startsWith("resultStatus")) {
                    resultStatus = gatValue(resultParam, "resultStatus");
                }
                if (resultParam.startsWith("result")) {
                    result = gatValue(resultParam, "result");
                }
                if (resultParam.startsWith("memo")) {
                    memo = gatValue(resultParam, "memo");
                }
            }
        }

        @Override
        public String toString() {
            return "resultStatus={" + resultStatus + "};memo={" + memo
                    + "};result={" + result + "}";
        }

        private String gatValue(String content, String key) {
            String prefix = key + "={";
            return content.substring(content.indexOf(prefix) + prefix.length(),
                    content.lastIndexOf("}"));
        }

        /**
         * @return the resultStatus
         */
        public String getResultStatus() {
            return resultStatus;
        }

        /**
         * @return the memo
         */
        public String getMemo() {
            return memo;
        }

        /**
         * @return the result
         */
        public String getResult() {
            return result;
        }
    }
}
