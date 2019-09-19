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

  renderButton(title, type) {
    return (

        <TouchableOpacity activeOpacity={0.8} onPress={this.share.bind(this, type)}>
          <View style={styles.button}>
            <Text style={styles.title}>
              {title}
            </Text>
          </View>
        </TouchableOpacity>

      )
  }

  render() {
    const types = Sns.snsShare.TYPES;
    return (
      <Fragment>
        <StatusBar barStyle="dark-content" />
        <SafeAreaView>
          <ScrollView
            contentInsetAdjustmentBehavior="automatic"
            style={styles.scrollView}>
            <View style={styles.content}>
            {
              this.renderButton('分享微信好友', types.WECHAT_SESSION)
            }
            {
              this.renderButton('分享朋友圈', types.WECHAT_TIMELINE)
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
