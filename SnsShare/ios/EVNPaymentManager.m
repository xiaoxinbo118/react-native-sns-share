//
//  EVNPaymentManager.m
//  EVNShare
//
//  Created by 1 on 2019/9/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNPaymentManager.h"
#import "EVNAliManager.h"
#import "EVNWXManager.h"

@interface EVNPaymentManager()

@property (nonatomic, copy) void(^commpletion)(NSString *code,NSError *error);

@end

@implementation EVNPaymentManager

/**
 *  支付引擎
 *
 *  @return 唯一实例
 */
+ (instancetype)defaultManager {
  static EVNPaymentManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[EVNPaymentManager alloc] init];
  });
  return manager;
}

- (void)pay:(EVNSnsPaymentType)type params:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion {
  
  if (type == EVNSnsPaymentWeChat) {
    [self payWX:EVNSnsPaymentWeChat params:params block:commpletion];
  } else if (type == EVNSnsPaymentAlipay) {
    [self payAli:type params:params block:commpletion];
  }
}

- (void)payAli:(EVNSnsPaymentType)type params:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion {
  NSString *orderStr = [params valueForKey:@"order"];
  NSString *scheme = [params valueForKey:@"scheme"];

  [[EVNAliManager defaultManager] payOrder:orderStr scheme:scheme callback:^(NSDictionary * _Nonnull resultDic) {
    NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
    BOOL success = resultStatus ? resultStatus == 9000 : NO;
    if (success) {
      commpletion(@"0", nil);
    } else {
      NSError *error = [[NSError alloc] initWithDomain:@"alipay" code:resultStatus userInfo:nil];
      commpletion([NSString stringWithFormat:@"%@", @(resultStatus)], error);
      self.commpletion = nil;
    }
  }];
}

- (void)payWX:(EVNSnsPaymentType)type params:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion {
  self.commpletion = commpletion;
  PayReq *request = [[PayReq alloc] init];
  
  request.partnerId = [params objectForKey:@"partnerId"];
  request.prepayId = [params objectForKey:@"prepayId"];
  request.package = [params objectForKey:@"package"];
  request.nonceStr = [params objectForKey:@"nonceStr"];
  long long timestamp = [[params objectForKey:@"timestamp"] longLongValue];
  // todo 类型转换 如果用 floatvalue 会导致跟服务器的返回值不一致
  request.timeStamp = timestamp; //[[params objectForKey:@"timestamp"] floatValue];
  request.sign = [params objectForKey:@"sign"];
  
  [[EVNWXManager defaultManager] sendReq:request completion:^(BOOL success) {
    if (!success) {
      NSError *error = [NSError errorWithDomain:@"snsShare" code:-3 userInfo:@{NSLocalizedDescriptionKey : @"check params and sign"}];
      commpletion(@"-3", error);
      self.commpletion = nil;
    }
  }];
}

#pragma wechat delegate
- (void)onResp:(BaseResp *)resp {
  if (!self.commpletion) {
    return;
  }
  
  if ([resp isKindOfClass:[PayResp class]]) {
    NSString *code = [NSString stringWithFormat:@"%@", @(resp.errCode)];
    if (resp.errCode == 0) {
      self.commpletion(@"0", nil);
    } else {
      self.commpletion(code, [NSError errorWithDomain:@"share" code:resp.errCode userInfo:nil]);;
    }
    
    self.commpletion = nil;
  }
}

@end
