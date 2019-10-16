import { NativeModules } from 'react-native';

const { RNSnsOAuth } = NativeModules;

export default snsShare = {
  TYPES: {
    WECHAT: 0,
    ALIPAY: 1,
    QQ: 2,
    WEIBO: 3,
  },
  /**
   *  授权认证
   * @param
   *        type 类型
   *        params 微信、新浪场景不需要传，支付宝场景需要通过服务端获取加密串，key为authLink  scheme。
   *
   * @return {Promise<any> result 传递给后台做认证， sina的场景下，需要解析格式为"user_id=%@&access_token=%@&expiration_date=%@&refresh_token=%@"}
   */
   auth(type, params) {
    return new Promise((resolve, reject) => {
      RNSnsOAuth && RNSnsOAuth.auth(type, params)
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
