import { NativeModules } from 'react-native';

const { RNSnsPayment } = NativeModules;

export default snsPayment = {
  TYPES: {
    WECHAT: 0,
    ALIPAY: 1,
  },
  /**
   *  分享到微信h5
   * @param {
   *        type: 类型
   *        params:支付保支付时，{ order:
     '"内容参考：partner="2088101568358171"&seller_id="xxx@alipay.com"&out_trade_no="0819145412-6177"&subject="测试"&body="测试测试"&total_fee="0.01"&notify_url="http://notify.msp.hk/notify.htm"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-*        8"&it_b_pay="30m"&sign="lBBK%2F0w5LOajrMrji7DUgEqNjIhQbidR13GovA5r3TgIbNqv231yC1NksLdw%2Ba3JnfHXoXuet6XNNHtn7VE%2BeCoRO1O%2BR1KugLrQEZMtG5jmJIe2pbjm%2F3kb%2FuGkpG%2BwYQYI51%2BhA3YBbvZHVQBYveBqK%2Bh8mUyb7GM1HxWs9k4%3D"&sign_type="RSA"',
   *          scheme:'com.xxx.xxx'
     },
   *        微信支付时，{
   *         partnerId:
   *         prepayId:
   *        package:
   *        nonceStr:
   *        timeStamp:
   *        sign:
   * }
   *    }
   * @return {Promise<any>}
   */
   pay(type, params) {
    return new Promise((resolve, reject) => {
      RNSnsPayment && RNSnsPayment.pay(type, params)
        .then((result) => {
          if (result) {
            resolve(result);
          }
        })
        .catch((error) => {
          reject(error);
        });
    });
  },
}
