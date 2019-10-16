//
//  RNSnsSocial.m
//  EVNShare
//
//  Created by 1 on 2019/9/11.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNSnsSocial.h"
#import "EVNWXManager.h"
#import "EVNWeiboManager.h"
#import "EVNShareManager.h"
#import "EVNSnsOAuthManager.h"
#import "EVNPaymentManager.h"

@implementation RNSnsSocial

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(registerApp:(NSDictionary *)appIds redirectUrls:(NSDictionary *)redirectUrls universalLink:(NSString *)universalLink) {
  NSString *wxAppId = [appIds valueForKey:@"wechart"];
  if (wxAppId) {
    [[EVNWXManager defaultManager] registerApp:wxAppId universalLink:universalLink];
    [[EVNWXManager defaultManager] setMessageDelegate:[EVNShareManager defaultManager]];
    [[EVNWXManager defaultManager] setPaymentDelegate:[EVNPaymentManager defaultManager]];
    [[EVNWXManager defaultManager] setAuthDelegate:[EVNSnsOAuthManager defaultManager]];
  }
 
  NSString *wbAppId = [appIds valueForKey:@"weibo"];
  NSString *redirectUrl = [redirectUrls valueForKey:@"weibo"];
  if (wbAppId) {
    [[EVNWeiboManager defaultManager] registerApp:wbAppId redirectUrl:redirectUrl];
    [[EVNWeiboManager defaultManager] setMessageDelegate:[EVNShareManager defaultManager]];
    [[EVNWeiboManager defaultManager] setAuthDelegate:[EVNSnsOAuthManager defaultManager]];
  }
}

@end
