/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import Sns from 'react-native-sns-share'

// 项目启动时，注册微信信息
Sns.snsSocial.registerApp({
  'wechart': 'wx111111',
  'weibo': null,
  'qq': '3333333',
}, {
  'weibo': null,
}, 'testing');
AppRegistry.registerComponent(appName, () => App);
