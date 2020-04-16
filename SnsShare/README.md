# react-native-sns-share
RN微信、微博、QQ及支付宝分享、授权登陆、支付插件。
暂时支持情况


|             | 分享         | 授权登陆     | 支付         |
| ----------- | ----------- | ----------- | ----------- |
|微信          | ✔           |  ✔           | ✔           |
|QQ           |  ✔           | ✔            | ×           |
|微博          |  ✔          | ✔           | ×           |
|支付宝        |  ×          |  ✔          | ✔           |

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
 2. 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“LSApplicationQueriesSchemes“添加weixin、wechat、weixinulapi（如下图所示）。

 ![xcode设置](http://mmbiz.qpic.cn/mmbiz_png/PiajxSqBRaEJsqKkSJGg4TLAxEIvWjtTfrHSbhE3zfbPzuuGzadu9FsWJuBNELsk1IuQucfx91ialTfpPhAF0grA/0?wx_fmt=png)

 #### 微博设置
 1. 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id
 2. 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“LSApplicationQueriesSchemes“添加weibosdk、weibosdk2.5

 #### 支付宝设置
  1. 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“LSApplicationQueriesSchemes“添加alipay、alipayauth
 #### QQ设置
  1. 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id
  2. 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“LSApplicationQueriesSchemes“mqq、mqqapi、mqqopensdkapiV3、mqqopensdkapiV2
  PS 参考Demo
 #### 统一设置
 1.Appdelegate 中添加处理回调
   ```c++
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  return [self application:application openURL:url];
}
// 微博web版本回掉时，会走此方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
  return [self application:application openURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url {
  BOOL handled = NO;

  handled = [EVNWeiboManager.defaultManager application:application openURL:url];

  if (handled) {
    return YES;
  }

  handled = [EVNAliManager.defaultManager application:application openURL:url];

  if (handled) {
    return YES;
  }

  handled = [EVNWXManager.defaultManager application:application openURL:url];

  if (handled) {
    return YES;
  }

  handled = [EVNQQManager.defaultManager application:application openURL:url];

  if (handled) {
    return YES;
  }

  return handled;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  [[EVNWeiboManager defaultManager] applicationWillEnterForeground:application];
  [[EVNWXManager defaultManager] applicationWillEnterForeground:application];
  [[EVNAliManager defaultManager] applicationWillEnterForeground:application];
  [[EVNQQManager defaultManager] applicationWillEnterForeground:application];
}
   ```

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
 1.Android工程代码下创建 包名+wxapi/WXEntryActivity.java / WXPayEntryActivity.java继承com.evan.sns.share.wxapi.WXEntryActivity

```java
package com.snssharedemo.wxapi;

public class WXEntryActivity extends  com.evan.sns.share.wxapi.WXEntryActivity {

}
```

```java
package com.snssharedemo.wxapi;

import com.evan.sns.share.wxapi.WXEntryActivity;

public class WXPayEntryActivity extends WXEntryActivity {

}


```

2.AndroidManifest.xml中设置
```xml
       <!--微信支付开始-->
       <activity
           android:name="com.snssharedemo.wxapi.WXPayEntryActivity"
           android:exported="true"
           android:launchMode="singleTop"
           android:theme="@android:style/Theme.NoDisplay" />
       <!--微信支付结束-->
       <!--微信分享开始-->
       <activity
           android:name="com.snssharedemo.wxapi.WXEntryActivity"
           android:exported="true"
           android:launchMode="singleTop"
           android:theme="@android:style/Theme.NoDisplay" />
       <!--微信分享结束-->
```
3.Project的gradle中设置

```gradle
allprojects {
   repositories {
       flatDir {
           dirs '../../node_modules/react-native-sns-share/android/libs'
       }
      ...
   }
}
```
  #### 微博设置
  1.MainActivity中重载onActivityResult，用于接收微博回调信息
 ```java
        @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // 接收微博分享后的返回值
        WeiboManager.getInstance().doResultIntent(requestCode, resultCode, data);
    }

 ```
 2.主build.gradle中添加
  ```gradle
 allprojects {
    repositories {
        ...
        maven { url "https://dl.bintray.com/thelasterstar/maven/" }
    }
}
 ```
 #### QQ设置
  1.AndroidManifest.xml中设置。AuthActivity中的Data为tencent+AppId
 ```xml
       <!--QQ分享开始-->
        <activity
            android:name="com.tencent.tauth.AuthActivity"
            android:noHistory="true"
            android:launchMode="singleTask" >
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="tencent1111" />
            </intent-filter>
        </activity>
        <activity
            android:name="com.tencent.connect.common.AssistActivity"
            android:configChanges="orientation|keyboardHidden"
            android:screenOrientation="behind"
            android:theme="@android:style/Theme.Translucent.NoTitleBar" />
        <!--QQ分享结束-->
 ```
   2.MainActivity中重载onActivityResult，用于接收QQ回调信息
 ```java
        @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // 接收QQ分享后的返回值
       QQManager.getInstance().doResultIntent(requestCode, resultCode, data);
    }

 ```
 ## 二. 使用

 ### 1. 注册App
 ```js
import Sns from 'react-native-sns-share'

// 项目启动时，注册微信、微博信息
Sns.snsSocial.registerApp({
  'wechart': 'wx11111111',
  'weibo': '2222222',
  'qq': '33333333',
}, {
  'weibo': 'https://www.baidu.com',
}, 'testing');
```
 ### 2. 分享调用
 ```js
 import Sns from 'src/react-native-sns-share'

 const types = Sns.snsShare.TYPES;

 Sns.snsShare.share({
  webpageUrl: 'https://www.baidu.com',
  title: '分享一下',
  description: '分享就用我',
  imageUrl: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568635646029&di=4f86fc970153b638fd4a404e2a780ed0&imgtype=0&src=http%3A%2F%2Fwww.cnr.cn%2Fjingji%2Ftxcj%2F20160727%2FW020160727318839106051.jpg',
  shareType: types.WECHAT_SESSION
  })
.then(() => {
    console.log('wx share success');
  })
.catch((error) => {
    console.log(error);
  })

 ```
types常量表

|    变量         |  含义        |
| ----------- | ----------- |
|WECHAT_SESSION| 微信好友          |
|WECHAT_TIMELINE| 微信朋友圈          |
|QQ_SESSION| QQ好友          |
|WEIBO| 微博          |
 ### 3. 支付调用
 ```js
    import Sns from 'react-native-sns-share'

    let params， type = Sns.snsPayment.TYPES.ALIPAY;

    if (type == Sns.snsPayment.TYPES.ALIPAY) {
      // order 数据尽量后太组装成功后返回，不要前台自己来拼写。 scheme为ios用的，在plist中配置
      params = {
        order:'partner=2088101568358171&seller_id=xxx@alipay.com&out_trade_no=0819145412-6177&subject=测试&body=测试测试&total_fee=0.01&notify_url=http://notify.msp.hk/notify.htm&service=mobile.securitypay.pay&payment_type=1&_input_charset=utf-8&it_b_pay=30m&sign=lBBK%2F0w5LOajrMrji7DUgEqNjIhQbidR13GovA5r3TgIbNqv231yC1NksLdw%2Ba3JnfHXoXuet6XNNHtn7VE%2BeCoRO1O%2BR1KugLrQEZMtG5jmJIe2pbjm%2F3kb%2FuGkpG%2BwYQYI51%2BhA3YBbvZHVQBYveBqK%2Bh8mUyb7GM1HxWs9k4%3D&sign_type=RSA',
        scheme: 'xxxx'
      }
    } else if (type == Sns.snsPayment.TYPES.WECHAT) {
      // 信息后台给到
      params = {
        partnerId:'',
        prepayId: 'xxxx',
        package: '',
        nonceStr: '',
        timeStamp:'',
        sign: '',
      }
    }

    Sns.snsPayment.pay(type, params)
    .then(() => {
        console.log('支付成功');
      })
    .catch((error) => {
        console.log(error);
        // 失败的场景下，最好重新拉取下api来判定是否成功。 有可能用户支付完成后，不点返回留在支付应用。
      })
 ```
types常量表

|    变量         |  含义        |
| ----------- | ----------- |
|WECHAT| 微信支付          |
|ALIPAY| 支付宝支付          |

 ### 4. 授权登录调用
 ```js
    import Sns from 'react-native-sns-share'

    let params, type
    if (type == Sns.snsOAuth.TYPES.ALIPAY) {
      // authLink 根据支付宝文档，后台做拼装加签
      params = {
        authLink:'XXX',
        scheme: 'xxxx'
      }
    }
    Sns.snsOAuth.auth(type, params)
    .then((result) => {

       // 调用后台服务，通过result做后续逻辑
       // 新浪场景格式为 "user_id=%@&access_token=%@&expiration_date=%@&refresh_token=%@"
        console.log('成功' + result);
      })
    .catch((error) => {
        console.log(error);
      })
 ```
 types常量表

|    变量         |  含义        |
| ----------- | ----------- |
|WECHAT| 微信          |
|ALIPAY| 支付宝          |
|WEIBO| 微博          |
|QQ| 微博          |




<div align='center'><img src="http://m.qpic.cn/psb?/V11WlCWW0HY4Ms/8Z4PimX9K4gJJ4n5.HZ7L0y*NiG4ViSu*LpQTcR2n8o!/b/dAYBAAAAAAAA&bo=OAQ4BAAAAAARBzA!&rf=viewer_4" width="300" height="300" /></div>
