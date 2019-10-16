//
//  RNSnsOAuth.m
//  EVNShare
//
//  Created by 1 on 2019/10/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNSnsOAuth.h"
#import "EVNSnsOAuthManager.h"

@implementation RNSnsOAuth

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(auth:(NSInteger)authType
                  params:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  
  [[EVNSnsOAuthManager defaultManager] auth:(EVNSnsOAuthType)authType params:params block:^(NSString * _Nonnull code, NSError * _Nonnull error) {
    if (error) {
      reject(code, @"授权失败", error);
    } else {
      resolve(code);
    }
  }];
}

@end
