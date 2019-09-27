//
//  RNSnsSocial.m
//  EVNShare
//
//  Created by 1 on 2019/9/11.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNSnsSocial.h"
#import "EVNWXManager.h"
#import "EVNShareManager.h"
#import "EVNPaymentManager.h"

@implementation RNSnsSocial

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(registerApp:(NSDictionary *)appIds) {
  NSString *wxAppId = [appIds valueForKey:@"wechart"];
  if (wxAppId) {
    [[EVNWXManager defaultManager] registerApp:wxAppId];
    [[EVNWXManager defaultManager] setMessageDelegate:[EVNShareManager defaultManager]];
    [[EVNWXManager defaultManager] setPaymentDelegate:[EVNPaymentManager defaultManager]];
  }
 
}

@end
