
#import "RNSnsShare.h"
#import "EVNShareManager.h"

@implementation RNSnsShare

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()


#pragma mark 分享
RCT_EXPORT_METHOD(share:(NSInteger)shareType
                  webpageUrl:(NSString *)webpageUrl
                  title:(NSString *)title
                  description:(NSString *)description
                  imageUrl:(NSString *)imageUrl
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )
{
    EVNShareModel *model = [[EVNShareModel alloc] init];
    model.desc = description;
    model.thumb = imageUrl;
    model.title = title;
    model.type = (EVNSnsShareType)shareType;
    model.webPageUrl = webpageUrl;

    [[EVNShareManager defaultManager] share:model block:^(NSString *code, NSError *error) {
      if (error) {
        reject(code, @"分享失败", error);
      } else {
        resolve(code);
      }
    }];
}

@end
