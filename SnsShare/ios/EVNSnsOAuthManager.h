//
//  EVNSnsOAuthManager.h
//  EVNShare
//
//  Created by 1 on 2019/10/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "EVNQQManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
  EVNSnsOAuthWeChat,
  EVNSnsOAuthAlipay,
  EVNSnsOAuthQQ,
  EVNSnsOAuthWeibo,
} EVNSnsOAuthType;

@interface EVNSnsOAuthManager : NSObject<WXApiDelegate, WeiboSDKDelegate, EVNQQDelegate>

/**
 *  授权引擎
 *
 *  @return 唯一实例
 */
+ (instancetype)defaultManager;

- (void)auth:(EVNSnsOAuthType)oAuthType params:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion;

@end

NS_ASSUME_NONNULL_END
