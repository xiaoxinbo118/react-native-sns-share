# react-native-sns-share
RN微信、微博、QQ分享插件。
暂时支持情况


|             | 分享         | 授权登陆     | 支付         |
| ----------- | ----------- | ----------- | ----------- |
|微信          | ✔           | ×           | ×           |
|QQ           |  ×          | ×           | ×           |
|微博          |  ×          | ×           | ×           |

PS：未支持部分，会在后续迭代中完成。

 ## 一. 起步
 
 1. 执行: `$ npm install --save react-native-npm-share --save`
 2. 执行: `$ react-native link react-native-sns-share`
 3. 对于您计划使用的每个平台（ios/android），请遵循相应平台的一个选项
 
 ### iOS
 1. 进入ios目录
 2. 执行: `$ pod update`
 
 #### 微信设置
 1. 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id（如下图所示）。
 ![xcode设置](https://res.wx.qq.com/op_res/qXIS1XaeAWkQxAJeyFfJPNQUfzVWbPnyqeYUTl3Q3rW1j29j5eQn4xaUNYXErjql)
 2. 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“LSApplicationQueriesSchemes“添加weixin（如下图所示）。
 
 ![xcode设置](http://mmbiz.qpic.cn/mmbiz_png/PiajxSqBRaEJsqKkSJGg4TLAxEIvWjtTfrHSbhE3zfbPzuuGzadu9FsWJuBNELsk1IuQucfx91ialTfpPhAF0grA/0?wx_fmt=png)
 
 ### Android
 确认MainApplication，getPackages中是否已经加入RNSnsSharePackage。
 若没有加入,getPackages中加入 packages.add(new RNSnsSharePackage());
  ```java
    @Override
    protected List<ReactPackage> getPackages() {
      @SuppressWarnings("UnnecessaryLocalVariable")
      List<ReactPackage> packages = new PackageList(this).getPackages();
      // Packages that cannot be autolinked yet can be added manually here, for example:
      // packages.add(new MyReactNativePackage());
      packages.add(new RNSnsSharePackage());
      return packages;
    }
```
 #### 微信设置
 AndroidManifest.xml中设置
 ```xml
         <!--微信开始-->
        <activity
            android:name="com.evan.sns.share.wxapi.WXEntryActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@android:style/Theme.NoDisplay" />
        <!--微信结束-->
 ```
 
 ## 二. 使用
 
 1. 注册App
 ```js
import Sns from './src/react-native-sns-share/index'

// 项目启动时，注册微信信息
Sns.snsSocial.registerApp({
  'wechart': 'wxxxxxxxxx'
});
```
