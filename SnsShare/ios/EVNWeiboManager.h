//
//  EVNWeiboManager.h
//  EVNShare
//
//  Created by 1 on 2019/10/8.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface EVNWeiboManager : NSObject<WeiboSDKDelegate>

/**
 *  微博sdk代理引擎
 *
 *  @return 返回唯一实例
 */
+ (instancetype)defaultManager;

@property (nonatomic, readonly) NSString *redirectUrl;

/**
 向微博客户端程序注册第三方应用
 @param appKey 微博开放平台第三方应用appKey
 @return 注册成功返回YES，失败返回NO
 */
- (BOOL)registerApp:(NSString *)appid redirectUrl:(NSString *)redirectUrl;

/**
 *  认证相关委托设置，处理：
 *  SendAuthReq/SendAuthResp
 *  请求或相应消息类型
 */
@property (nonatomic,weak) id<WeiboSDKDelegate> authDelegate;//认证相关的委托处理

/**
 *  分享相关委托，处理：
 *  请求或相应消息类型
 */
@property (nonatomic,weak) id<WeiboSDKDelegate> messageDelegate;//分享相关委托

- (BOOL)sendRequest:(WBBaseRequest *)request;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
