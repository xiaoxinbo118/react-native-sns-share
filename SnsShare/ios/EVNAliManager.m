//
//  EVNAliManager.m
//  EVNShare
//
//  Created by 1 on 2019/9/25.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNAliManager.h"
#import <AlipaySDK/AlipaySDK.h>

NSString *const AlipayHost = @"safepay";

@interface EVNAliManager()

@property (nonatomic,strong) NSMutableDictionary *payCallbacks;
@property (nonatomic,strong) NSMutableDictionary *authCallbacks;

@end

@implementation EVNAliManager

+ (instancetype)defaultManager {
  static EVNAliManager *engine = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    engine = [[EVNAliManager alloc] init];
  });
  return engine;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.payCallbacks = [[NSMutableDictionary alloc] initWithCapacity:1];
    self.authCallbacks = [[NSMutableDictionary alloc] initWithCapacity:1];
  }
  return self;
}

/**
 *  是否已经使用过
 *
 *  @return YES为已经使用过，NO反之
 */
- (BOOL)isLogined {
  return [[AlipaySDK defaultService] isLogined];
}

/**
 *  当前版本号
 *
 *  @return 当前版本字符串
 */
- (NSString *)currentVersion {
  return [[AlipaySDK defaultService] currentVersion];
}

/**
 *  支付接口
 *
 *  @param orderStr       订单信息
 *  @param compltionBlock 支付结果回调Block
 */
- (void)payOrder:(NSString *)orderStr
          scheme:(NSString *)scheme
        callback:(void(^)(NSDictionary *resultDic))completionBlock {
  if ([orderStr length] == 0) {
    if (completionBlock) {
      completionBlock(nil);
    }
    return ;
  }
  
  NSLog(@"开始支付订单【%@】",orderStr);
  
  void(^alisdk_block)(NSDictionary *resultDic) = ^(NSDictionary *resultDic) {
    
    if (completionBlock) {
      completionBlock(resultDic);
    }
    
    NSLog(@"订单【%@】支付结果完成",orderStr);
    [self.payCallbacks removeObjectForKey:orderStr];//移除queue
  };
  
  void(^inner_block)(NSDictionary *resultDic,NSString *key) = ^(NSDictionary *resultDic,NSString *key) {
    
    if (![key isEqualToString:orderStr]) {//并不是当前请求，不需要处理
      return ;
    }
    
    alisdk_block(resultDic);//可以处理
  };
  
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
  
  [_payCallbacks setObject:inner_block forKey:orderStr];
  [[AlipaySDK defaultService] payOrder:orderStr fromScheme:scheme callback:alisdk_block];
}

/**
 *  快登授权2.0
 *
 *  @param infoStr         授权请求信息字符串
 *  @param scheme          调用授权的app注册在info.plist中的scheme
 *  @param completionBlock 授权结果回调
 */
- (void)authWithInfo:(NSString *)infoStr scheme:(NSString *)scheme callback:(void(^)(NSDictionary *resultDic))completionBlock {
  if ([infoStr length] == 0) {
    if (completionBlock) {
      completionBlock(nil);
    }
    return ;
  }
  
  
  void(^alisdk_block)(NSDictionary *resultDic) = ^(NSDictionary *resultDic) {
    
    if (completionBlock) {
      completionBlock(resultDic);
    }
    
    
    [self.authCallbacks removeObjectForKey:infoStr];//移除queue
  };
  
  void(^inner_block)(NSDictionary *resultDic,NSString *key) = ^(NSDictionary *resultDic,NSString *key) {
    
    if (![key isEqualToString:infoStr]) {//并不是当前请求，不需要处理
      return ;
    }
    
    alisdk_block(resultDic);//可以处理
  };
  
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
  
  [_authCallbacks setObject:inner_block forKey:infoStr];
  [[AlipaySDK defaultService] auth_V2WithInfo:infoStr fromScheme:scheme callback:alisdk_block];
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url {
  
  if ([url.host isEqualToString:AlipayHost]) {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
    
    if ([self.authCallbacks count]) {//对每个请求的callback都遍历返回
      
      NSDictionary *callbacks = [self.authCallbacks copy];
      NSArray *keys = [callbacks allKeys];

      void (^callback)(NSDictionary *resultDic) = ^(NSDictionary *resultDic){
        //遍历返回
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
          void(^inner_block)(NSDictionary *resultDic,NSString *key) = [callbacks objectForKey:key];
          inner_block(resultDic,key);
        }];
      };
      [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:callback];
      
    }
    
    if ([self.payCallbacks count]) {
      NSDictionary *callbacks = [self.payCallbacks copy];
      NSArray *keys = [callbacks allKeys];
      
      void (^callback)(NSDictionary *resultDic) = ^(NSDictionary *resultDic){
        //遍历返回
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
          void(^inner_block)(NSDictionary *resultDic,NSString *key) = [callbacks objectForKey:key];
          inner_block(resultDic,key);
        }];
      };
      
      [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:callback];
      
    }
    return YES;
    
  }
  
  return NO;
}

- (void)delayCheckAlipaySDKCallbacks {
  
  if ([self.authCallbacks count]) {//对每个请求的callback都遍历返回
    
    NSDictionary *callbacks = [self.authCallbacks copy];
    NSArray *keys = [callbacks allKeys];
    
    //遍历返回
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
      void(^inner_block)(NSDictionary *resultDic,NSString *key) = [callbacks objectForKey:key];
      inner_block(nil,key);
    }];
  }
  
  if ([self.payCallbacks count]) {
    NSDictionary *callbacks = [self.payCallbacks copy];
    NSArray *keys = [callbacks allKeys];
    
    //遍历返回
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
      void(^inner_block)(NSDictionary *resultDic,NSString *key) = [callbacks objectForKey:key];
      inner_block(nil,key);
    }];
  }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  SEL sel = @selector(delayCheckAlipaySDKCallbacks);
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
  [self performSelector:sel withObject:nil afterDelay:2];
}

@end
