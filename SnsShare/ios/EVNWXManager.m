//
//  EVNWXManager.m
//  EVNShare
//
//  Created by 1 on 2019/9/11.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNWXManager.h"

@interface EVNWXManager ()<WXApiDelegate>

@property (nonatomic,strong) NSMutableArray *reqQueue;
@property (nonatomic,strong) NSMutableArray *resQueue;

@end

@implementation EVNWXManager

+ (instancetype)defaultManager {
  static EVNWXManager *engine = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    engine = [[EVNWXManager alloc] init];
  });
  return engine;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _reqQueue = [[NSMutableArray alloc] initWithCapacity:1];
    _resQueue = [[NSMutableArray alloc] initWithCapacity:1];
  }
  return self;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
{
  BOOL isSuccess = [WXApi handleOpenURL:url delegate:self];
  if (isSuccess) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckCallbacks) object:nil];
  }
  NSLog(@"url %@ isSuccess %d",url,isSuccess == YES ? 1 : 0);
  return  isSuccess;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  SEL sel = @selector(delayCheckCallbacks);
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCheckCallbacks) object:nil];
  [self performSelector:sel withObject:nil afterDelay:2];
}

- (void)delayCheckCallbacks {
  
  //需要分别模仿
  [_reqQueue enumerateObjectsUsingBlock:^(BaseReq *req, NSUInteger idx, BOOL *stop) {
    if ([req isKindOfClass:[SendMessageToWXReq class]]) {
      SendMessageToWXResp *res = [[SendMessageToWXResp alloc] init];
      res.errCode = -2;
      [self.messageDelegate onResp:res];
    }
    else if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
      GetMessageFromWXResp *res = [[GetMessageFromWXResp alloc] init];
      res.errCode = -2;
      [self.messageDelegate onResp:res];
    }
    else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
      ShowMessageFromWXResp *res = [[ShowMessageFromWXResp alloc] init];
      res.errCode = -2;
      [self.messageDelegate onResp:res];
    }
    else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
      [self.messageDelegate onReq:req];
    }
    else if ([req isKindOfClass:[PayReq class]]) {
      PayResp *res = [[PayResp alloc] init];
      res.errCode = -2;
      [self.paymentDelegate onResp:res];
    }
    else if ([req isKindOfClass:[SendAuthReq class]]) {
      SendAuthResp *res = [[SendAuthResp alloc] init];
      res.errCode = -2;
      res.state = [(SendAuthReq *)req state];
      [self.authDelegate onResp:res];
    }
  }];
  [_reqQueue removeAllObjects];
}

#pragma mark - WXAPI
- (void)sendReq:(BaseReq*)req completion:(void (^ __nullable)(BOOL success))completion {
  [WXApi sendReq:req completion:completion];
}

- (BOOL)registerApp:(NSString *)appid universalLink:(NSString *)universalLink {
  BOOL result = [WXApi registerApp:appid universalLink:universalLink];
  return result;
}

/*! @brief 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
- (BOOL)isWXAppInstalled {
  return [WXApi isWXAppInstalled];
}

/*! @brief 判断当前微信的版本是否支持OpenApi
 *
 * @return 支持返回YES，不支持返回NO。
 */
- (BOOL)isWXAppSupportApi {
  return [WXApi isWXAppSupportApi];
}

/*! @brief 获取微信的itunes安装地址
 *
 * @return 微信的安装地址字符串。
 */
- (NSString *)getWXAppInstallUrl {
  return [WXApi getWXAppInstallUrl];
}

/*! @brief 获取当前微信SDK的版本号
 *
 * @return 返回当前微信SDK的版本号
 */
- (NSString *)getApiVersion {
  return [WXApi getApiVersion];
}

/*! @brief 打开微信
 *
 * @return 成功返回YES，失败返回NO。
 */
- (BOOL)openWXApp {
  return [WXApi openWXApp];
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp {
  if ([resp isKindOfClass:[SendMessageToWXResp class]]
      || [resp isKindOfClass:[GetMessageFromWXResp class]]
      || [resp isKindOfClass:[ShowMessageFromWXResp class]]) {
    [self.messageDelegate onResp:resp];
  }
  else if ([resp isKindOfClass:[PayResp class]]) {
    [self.paymentDelegate onResp:resp];
  }
  else if ([resp isKindOfClass:[SendAuthResp class]]) {
    [self.authDelegate onResp:resp];
  }
  
  //移除最后一个
  [_reqQueue removeLastObject];
}

@end
