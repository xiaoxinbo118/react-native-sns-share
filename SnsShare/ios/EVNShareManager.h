//
//  EVNShareManager.h
//  EVNShare
//
//  Created by Evan Xiao on 2019/9/11.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVNShareModel.h"
#import "WXApi.h"
#import "WeiboSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface EVNShareManager : NSObject<WXApiDelegate, WeiboSDKDelegate>

+ (EVNShareManager *)defaultManager;

- (void)share:(EVNShareModel *)shareModel block:(void(^)(NSString *code, NSError *error))commpletion;

@end

NS_ASSUME_NONNULL_END
