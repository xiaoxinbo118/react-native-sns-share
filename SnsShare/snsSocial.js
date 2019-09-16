import { NativeModules } from 'react-native';

const { RNSnsSocial } = NativeModules;


export default snsSocial = {
  /**
   *  向微信终端程序注册第三方应用。
   * @param appId 微信开发者ID
   */
   registerWXApp(appId) {
     RNSnsSocial && RNSnsSocial.registerWXApp(appId);
   },
}
