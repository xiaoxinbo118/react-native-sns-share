# react-native-sns-share
RN微信、微博、QQ及支付宝分享、授权登陆、支付插件。
暂时支持情况


|             | 分享         | 授权登陆     | 支付         |
| ----------- | ----------- | ----------- | ----------- |
|微信          | ✔           | ×           | ✔           |
|QQ           |  ×          | ×           | ×           |
|微博          |  ✔          | ×           | ×           |
|支付宝        |  ×          | ×           | ✔           |

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
 
 #### 统一设置
   ```object c
   // 处理回掉
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  BOOL handled = NO;
  
  handled = [EVNWeiboManager.defaultManager application:app openURL:url];
  
  if (handled) {
    return YES;
  }
  
  handled = [EVNWeiboManager.defaultManager application:app openURL:url];
  
  if (handled) {
    return YES;
  }
  
  handled = [EVNWXManager.defaultManager application:app openURL:url];
  
  if (handled) {
    return YES;
  }
  
  return handled;
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
 1.AndroidManifest.xml中设置
 ```xml
         <!--微信开始-->
        <activity
            android:name="com.evan.sns.share.wxapi.WXEntryActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@android:style/Theme.NoDisplay" />
        <!--微信结束-->
 ```
 2.Project的gradle中设置
 
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
  1.MainActivity中重载onActivityResult，用于接收微博回掉信息
 ```java
        @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // 接收微博分享后的返回值
        WeiboManager.getInstance().doResultIntent(data);
    }

 ```
 
 ## 二. 使用
 
 1. 注册App
 ```js
import Sns from 'react-native-sns-share'

// 项目启动时，注册微信信息
Sns.snsSocial.registerApp({
  'wechart': 'wxxxxxxxxx'
});
```
2. 分享调用
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
3. 支付调用
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
 
