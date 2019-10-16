import { NativeModules } from 'react-native';

const { RNSnsSocial } = NativeModules;


export default snsSocial = {
  /**
   *  向微信终端程序注册第三方应用。
   * @param appIds 微信开发者ID
   * @param redirectUrls 新浪web授权成功后的回掉地址
   * @param universalLink iOS 微信后台注册的universalLink
   */
   registerApp(appIds, redirectUrls, universalLink) {
     RNSnsSocial && RNSnsSocial.registerApp(appIds, redirectUrls, universalLink);
   },
}
