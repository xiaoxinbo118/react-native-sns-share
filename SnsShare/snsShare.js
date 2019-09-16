import { NativeModules } from 'react-native';

const { RNSnsShare } = NativeModules;

export default snsShare = {
  TYPES: {
    WECHAT_SESSION: 1,
    WECHAT_TIMELINE: 2,
    QQ_SESSION: 3,
    WEIBO: 4,
  },
  /**
   *  分享到微信h5
   * @param {
   *        webpageUrl： 网页url
   *        title:标题
   *        description: 描述
   *        image:图片
   *        shareType:分享类型
   *    }
   * @return {Promise<any>}
   */
   share({webpageUrl, title, description, imageUrl, shareType = TYPES.WECHAT_SESSION}) {
    return new Promise((resolve, reject) => {
      RNSnsShare && RNSnsShare.share(shareType, webpageUrl, title, description, imageUrl)
        .then((result) => {
          if (result) {
            resolve(result);
          }
        })
        .catch((error) => {
          reject(error);
        });
    });
  },
}
