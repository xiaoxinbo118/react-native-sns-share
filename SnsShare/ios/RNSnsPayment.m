//
//  RNSnsPayment.m
//  EVNShare
//
//  Created by 1 on 2019/9/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNSnsPayment.h"
#import "EVNPaymentManager.h"

@implementation RNSnsPayment

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

#pragma mark 支付
/**
 params: 支付保支付时，{ order: '"内容参考：partner="2088101568358171"&seller_id="xxx@alipay.com"&out_trade_no="0819145412-6177"&subject="测试"&body="测试测试"&total_fee="0.01"&notify_url="http://notify.msp.hk/notify.htm"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&sign="lBBK%2F0w5LOajrMrji7DUgEqNjIhQbidR13GovA5r3TgIbNqv231yC1NksLdw%2Ba3JnfHXoXuet6XNNHtn7VE%2BeCoRO1O%2BR1KugLrQEZMtG5jmJIe2pbjm%2F3kb%2FuGkpG%2BwYQYI51%2BhA3YBbvZHVQBYveBqK%2Bh8mUyb7GM1HxWs9k4%3D"&sign_type="RSA"',
     scheme:'com.xxx.xxx'
     },
 微信支付时，{
   partnerId:
   prepayId:
   package:
   nonceStr:
   timeStamp:
   sign:
 }
 
 **/
RCT_EXPORT_METHOD(pay:(NSInteger)payType
                  params:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  ) {
  [[EVNPaymentManager defaultManager] pay:(EVNSnsPaymentType)payType params:params block:^(NSString * _Nonnull code, NSError * _Nonnull error) {
    if (error) {
      reject(code, @"支付失败", error);
    } else {
      resolve(code);
    }
  }];
}

@end
