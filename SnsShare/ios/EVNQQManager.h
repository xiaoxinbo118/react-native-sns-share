//
//  EVNQQManager.h
//  EVNShare
//
//  Created by 1 on 2019/10/18.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import<TencentOpenAPI/TencentOAuth.h>
#import<TencentOpenAPI/TencentOAuthObject.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EVNQQDelegate <NSObject>

/**
 处理来至QQ的请求
 */
- (void)onQQReq:(QQBaseReq *)req;

/**
 处理来至QQ的响应
 */
- (void)onQQResp:(QQBaseResp *)resp;

@end

@interface EVNQQManager : NSObject<QQApiInterfaceDelegate, TencentSessionDelegate>

/**
 *  QQ sdk代理引擎
 *
 *  @return 返回唯一实例
 */
+ (instancetype)defaultManager;

@property (nonatomic, weak) id<EVNQQDelegate> shareDelegate;

/**
 *  认证相关委托设置，处理：
 *  SendAuthReq/SendAuthResp
 *  请求或相应消息类型
 */
@property (nonatomic,weak) id<EVNQQDelegate> authDelegate;//认证相关的委托处理

/**
 向手Q发起分享请求
 \param req 分享内容的请求
 \return 请求发送结果码
 */
- (void)sendReq:(QQBaseReq *)req;

- (void)authorize;

- (void)registerApp:(NSString *)appid;


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
