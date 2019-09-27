//
//  EVNWXManager.h
//  EVNShare
//
//  Created by 1 on 2019/9/11.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface EVNWXManager : NSObject

/**
 *  微信sdk代理引擎
 *
 *  @return 返回唯一实例
 */
+ (instancetype)defaultManager;

/**
 *  分享相关委托，处理：
 *  SendMessageToWXReq/SendMessageToWXResp
 *  GetMessageFromWXReq/GetMessageFromWXResp
 *  ShowMessageFromWXReq/ShowMessageFromWXResp
 *  LaunchFromWXReq
 *  请求或相应消息类型
 */
@property (nonatomic,weak) id<WXApiDelegate> messageDelegate;//分享相关委托

/**
 *  分享相关委托，处理：
 *  SendMessageToWXReq/SendMessageToWXResp
 *  GetMessageFromWXReq/GetMessageFromWXResp
 *  ShowMessageFromWXReq/ShowMessageFromWXResp
 *  LaunchFromWXReq
 *  请求或相应消息类型
 */
@property (nonatomic,weak) id<WXApiDelegate> paymentDelegate;//分享相关委托

/*! @brief WXApi的成员函数，向微信终端程序注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现，默认开启MTA数据上报。
 * iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。
 * @attention 请保证在主线程中调用此函数
 * @param appid 微信开发者ID
 * @return 成功返回YES，失败返回NO。
 */
- (BOOL)registerApp:(NSString *)appid;

/*! @brief 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
- (BOOL)isWXAppInstalled;

/*! @brief 判断当前微信的版本是否支持OpenApi
 *
 * @return 支持返回YES，不支持返回NO。
 */
- (BOOL)isWXAppSupportApi;

/*! @brief 获取微信的itunes安装地址
 *
 * @return 微信的安装地址字符串。
 */
- (NSString *)getWXAppInstallUrl;

/*! @brief 获取当前微信SDK的版本号
 *
 * @return 返回当前微信SDK的版本号
 */
- (NSString *)getApiVersion;

/*! @brief 打开微信
 *
 * @return 成功返回YES，失败返回NO。
 */
- (BOOL)openWXApp;

/*! @brief 发送请求到微信，等待微信返回onResp
 *
 * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
 * SendMessageToWXReq。
 * @param req 具体的发送请求，在调用函数后，请自己释放。
 * @param completion 成功返回YES，失败返回NO。
 */
- (void)sendReq:(BaseReq*)req completion:(void (^ __nullable)(BOOL success))completion;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
