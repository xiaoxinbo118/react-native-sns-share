//
//  EVNAliManager.h
//  EVNShare
//
//  Created by 1 on 2019/9/25.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const AlipayHost;

@interface EVNAliManager : NSObject<UIApplicationDelegate>

/**
 *  支付宝代理引擎
 *
 *  @return 返回唯一实例
 */
+ (instancetype)defaultManager;

/**
 *  是否已经使用过
 *
 *  @return YES为已经使用过，NO反之
 */
- (BOOL)isLogined;

/**
 *  当前版本号
 *
 *  @return 当前版本字符串
 */
- (NSString *)currentVersion;

/**
 *  支付接口
 *
 *  @param orderStr       订单信息
 *  @param scheme         用于支付宝跳回
 *  @param compltionBlock 支付结果回调Block
 */
- (void)payOrder:(NSString *)orderStr
          scheme:(NSString *)scheme
        callback:(void(^)(NSDictionary *resultDic))completionBlock;

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
