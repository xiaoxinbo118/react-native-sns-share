//
//  EVNPaymentManager.h
//  EVNShare
//
//  Created by 1 on 2019/9/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
  EVNSnsPaymentWeChat,
  EVNSnsPaymentAlipay,
} EVNSnsPaymentType;

@interface EVNPaymentManager : NSObject<WXApiDelegate>

+ (EVNPaymentManager *)defaultManager;

- (void)pay:(EVNSnsPaymentType)type params:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion;

@end

NS_ASSUME_NONNULL_END
