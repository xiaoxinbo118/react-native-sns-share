//
//  EVNWeiboManager.m
//  EVNShare
//
//  Created by 1 on 2019/10/8.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNWeiboManager.h"

@interface EVNWeiboManager()

@property (nonatomic,strong) NSMutableArray *reqQueue;

@end

@implementation EVNWeiboManager

+ (instancetype)defaultManager {
  static EVNWeiboManager *engine = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    engine = [[EVNWeiboManager alloc] init];
  });
  return engine;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _reqQueue = [[NSMutableArray alloc] initWithCapacity:1];
  }
  return self;
}

- (BOOL)registerApp:(NSString *)appid {
  //注册appId
  return [WeiboSDK registerApp:appid];
}

- (void)delayCheckAlipaySDKCallbacks
{
  //需要分别模仿
  [_reqQueue enumerateObjectsUsingBlock:^(WBBaseRequest  *req, NSUInteger idx, BOOL *stop) {
    if ([req isKindOfClass:[WBSendMessageToWeiboRequest class]]) {
      WBSendMessageToWeiboResponse *resp = [[WBSendMessageToWeiboResponse alloc] init];
      resp.statusCode = WeiboSDKResponseStatusCodeSentFail;
      [self.messageDelegate didReceiveWeiboResponse:resp];
    }
  }];
  [_reqQueue removeAllObjects];
  
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  BOOL isSuccess = [WeiboSDK handleOpenURL:url delegate:self];
  if (isSuccess) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
  }
  
  return  isSuccess;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  SEL sel = @selector(delayCheckAlipaySDKCallbacks);
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
  [self performSelector:sel withObject:nil afterDelay:2];
}

- (BOOL)sendRequest:(WBBaseRequest *)request
{
  BOOL result = [WeiboSDK sendRequest:request];
  if (result) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
    [_reqQueue addObject:request];
  }
  return result;
}

/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
  // TODO 这期没有 暂时不实现
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
  if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
    if ([self.messageDelegate respondsToSelector:@selector(didReceiveWeiboResponse:)]) {
      [self.messageDelegate didReceiveWeiboResponse:response];
    }
  }
}

@end
