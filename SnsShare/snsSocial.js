import { NativeModules } from 'react-native';

const { RNSnsSocial } = NativeModules;


export default snsSocial = {
  /**
   *  向微信终端程序注册第三方应用。
   * @param appIds 微信开发者ID
   * @param universalLink iOS 微信后台注册的universalLink
   */
   registerApp(appIds, universalLink) {
     RNSnsSocial && RNSnsSocial.registerApp(appIds, universalLink);
   },
}
