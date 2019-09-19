# react-native-sns-share
RN微信、微博、QQ分享插件。
暂时支持情况


|             | 分享         | 授权登陆     | 支付         |
| ----------- | ----------- | ----------- | ----------- |
|微信          | ✔           | ×           | ×           |
|QQ           |  ×          | ×           | ×           |
|微博          |  ×          | ×           | ×           |

 ## 一. 起步
 
 1. 执行: `$ npm install --save react-native-npm-share --save`
 2. 执行: `$ react-native link react-native-sns-share`
 3. 对于您计划使用的每个平台（ios/android），请遵循相应平台的一个选项
 
 ### iOS
 1. 进入ios目录
 2. 执行: `$ pod update`
 3.
 
 ### Android
 
 ## 二. 使用
 
 1. 注册App
 ```js
import Sns from './src/react-native-sns-share/index'

// 项目启动时，注册微信信息
Sns.snsSocial.registerApp({
  'wechart': 'wxxxxxxxxx'
});
```
