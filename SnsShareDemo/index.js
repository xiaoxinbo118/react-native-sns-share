/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import Sns from 'react-native-sns-share'

// 项目启动时，注册微信信息
Sns.snsSocial.registerApp({
  'wechart': 'wxc9e5245993bab87d',
  'weibo': '3590073357',
}, {
  'weibo': 'https://www.baidu.com',
}, 'testing');
AppRegistry.registerComponent(appName, () => App);
