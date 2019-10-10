/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Fragment, Component} from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  TouchableOpacity,
} from 'react-native';

import Sns from 'react-native-sns-share'
import {
  Colors,
} from 'react-native/Libraries/NewAppScreen';

class App extends Component {

  share(type) {
    Sns.snsShare.share({
      webpageUrl: 'https://www.baidu.com',
      title: '分享一下',
      description: '分享就用我',
      imageUrl: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568635646029&di=4f86fc970153b638fd4a404e2a780ed0&imgtype=0&src=http%3A%2F%2Fwww.cnr.cn%2Fjingji%2Ftxcj%2F20160727%2FW020160727318839106051.jpg',
      shareType: type
      })
    .then(() => {
        console.log('wx share success');
      })
    .catch((error) => {
        console.log(error);
      })

  }

  pay(type) {
    let params ;

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
  }

  renderButton(title, type, onClick) {
    return (

        <TouchableOpacity activeOpacity={0.8} onPress={onClick.bind(this, type)}>
          <View style={styles.button}>
            <Text style={styles.title}>
              {title}
            </Text>
          </View>
        </TouchableOpacity>

      )
  }

  render() {
    const shareTypes = Sns.snsShare.TYPES;
    const payTypes = Sns.snsPayment.TYPES;
    return (
      <Fragment>
        <StatusBar barStyle="dark-content" />
        <SafeAreaView>
          <ScrollView
            contentInsetAdjustmentBehavior="automatic"
            style={styles.scrollView}>
            <View style={styles.content}>
            {
              this.renderButton('分享微信好友', shareTypes.WECHAT_SESSION, this.share)
            }
            {
              this.renderButton('分享朋友圈', shareTypes.WECHAT_TIMELINE, this.share)
            }
            {
              this.renderButton('分享微博', shareTypes.WECHAT_TIMELINE, this.share)
            }
            {
              this.renderButton('微信支付', payTypes.WECHAT, this.pay)
            }
            {
              this.renderButton('支付宝支付', payTypes.ALIPAY, this.pay)
            }
            </View>
          </ScrollView>
        </SafeAreaView>
      </Fragment>
    );
  }
};

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.lighter,

  },
  content: {
    paddingTop: 100,
    paddingLeft: 30,
    paddingRight: 30,
  },
  body: {
    backgroundColor: Colors.lighter,
  },
  button: {
    backgroundColor: '#e62117',
    height: 44,
    width: '100%',
    borderRadius: 20,
    marginBottom: 25,
  },
  title: {
    color: '#fff',
    fontSize: 16,
    textAlign: 'center',
    lineHeight: 44,
  }
});

export default App;
