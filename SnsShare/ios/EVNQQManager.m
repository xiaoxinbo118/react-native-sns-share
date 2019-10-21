//
//  EVNQQManager.m
//  EVNShare
//
//  Created by 1 on 2019/10/18.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNQQManager.h"

@interface EVNQQManager()

@property (nonatomic,strong) NSMutableArray *reqQueue;
@property (nonatomic, strong) TencentOAuth *auth;
@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, strong) QQBaseReq *request;

@end

@implementation EVNQQManager

+ (instancetype)defaultManager {
  static EVNQQManager *engine = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    engine = [[EVNQQManager alloc] init];
  });
  return engine;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _reqQueue = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    self.permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
  }
  return self;
}

- (void)registerApp:(NSString *)appid {
  //注册appId
  self.auth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url {
  return [QQApiInterface handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

- (void)delayCheckAlipaySDKCallbacks {
  
  //需要分别模仿
  [_reqQueue enumerateObjectsUsingBlock:^(QQBaseReq *req, NSUInteger idx, BOOL *stop) {
    if ([req isKindOfClass:[SendMessageToQQReq class]]) {
      SendMessageToQQResp *resp = [SendMessageToQQResp respWithResult:nil errorDescription:@"分享失败" extendInfo:nil];
      [self.shareDelegate onQQResp:resp];
    }
    else if ([req isKindOfClass:[GetMessageFromQQReq class]]) {
      GetMessageFromQQResp *resp = [GetMessageFromQQResp respWithContent:nil];
      [self.shareDelegate onQQResp:resp];
    }
    else if ([req isKindOfClass:[ShowMessageFromQQReq class]]) {
      ShowMessageFromQQResp *resp = [ShowMessageFromQQResp respWithResult:nil errorDescription:@"分享失败"];
      [self.shareDelegate onQQResp:resp];
    }
  }];
  [_reqQueue removeAllObjects];
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  SEL sel = @selector(delayCheckAlipaySDKCallbacks);
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
  [self performSelector:sel withObject:nil afterDelay:2];
}

/**
 向手Q发起分享请求
 \param req 分享内容的请求
 \return 请求发送结果码
 */
- (void)sendReq:(QQBaseReq *)req
{
  if (self.auth.isSessionValid) {
    self.request = req;
    [self.auth authorize:self.permissions inSafari:NO];
  } else {
    QQApiSendResultCode code =[QQApiInterface sendReq:req];
    
    if (code == EQQAPISENDSUCESS) {
      [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckAlipaySDKCallbacks) object:nil];
      [_reqQueue addObject:req];
    }
  }
}

- (void)authorize {
  [self.auth authorize:self.permissions inSafari:NO];
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
  if (self.auth.accessToken && 0 != [self.auth.accessToken length]) {
    //  记录登录用户的OpenID、Token以及过期时间
    
    if (self.request) {
      // 分享时
      [self sendReq:self.request];
    } else {
      NSString *result = [NSString stringWithFormat:@"open_id=%@&access_token=%@&expiration_date=%@",self.auth.openId, self.auth.accessToken, @(self.auth.expirationDate.timeIntervalSince1970)];
      SendMessageToQQResp *resp = [SendMessageToQQResp respWithResult:result errorDescription:nil extendInfo:nil];
      [self.authDelegate onQQResp:resp];
    }
  } else {
    if (self.request && [self.shareDelegate respondsToSelector:@selector(onResp:)]) {
      SendMessageToQQResp *resp = [SendMessageToQQResp respWithResult:nil errorDescription:@"授权失败" extendInfo:nil];
      
      [self.shareDelegate onQQResp:resp];
    }
  }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
  
  SendMessageToQQResp *resp = [SendMessageToQQResp respWithResult:nil errorDescription:@"授权失败" extendInfo:nil];
  if (self.request) {
    [self.shareDelegate onQQResp:resp];
  } else  {
    [self.authDelegate onQQResp:resp];
  }
  
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
  SendMessageToQQResp *resp = [SendMessageToQQResp respWithResult:nil errorDescription:@"授权失败" extendInfo:nil];
  if (self.request) {
    [self.shareDelegate onQQResp:resp];
  } else {
    [self.authDelegate onQQResp:resp];
  }
}

/*! @brief 发送一个sendReq后，收到的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(QQBaseResp *)resp {
  if ([resp isKindOfClass:[SendMessageToQQResp class]]
      || [resp isKindOfClass:[GetMessageFromQQResp class]]
      || [resp isKindOfClass:[ShowMessageFromQQResp class]]) {
    [self.shareDelegate onQQResp:resp];
  }
  
  //移除最后一个
  [_reqQueue removeLastObject];
}

- (void)onReq:(QQBaseReq *)req
{
  
}

- (void)isOnlineResponse:(NSDictionary *)response {
  
}

@end
