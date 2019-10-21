//
//  EVNSnsOAuthManager.m
//  EVNShare
//
//  Created by 1 on 2019/10/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNSnsOAuthManager.h"
#import "EVNWXManager.h"
#import "EVNAliManager.h"
#import "EVNWeiboManager.h"

@interface EVNSnsOAuthManager()

@property (nonatomic, copy) void(^commpletion)(NSString *code,NSError *error);

@end

@implementation EVNSnsOAuthManager

/**
 *  授权引擎
 *
 *  @return 唯一实例
 */
+ (instancetype)defaultManager {
  static EVNSnsOAuthManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[EVNSnsOAuthManager alloc] init];
  });
  return manager;
}

- (void)auth:(EVNSnsOAuthType)oAuthType params:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion {
  if (oAuthType == EVNSnsOAuthWeChat) {
    [self wxAuth:params block:commpletion];
  } else if (oAuthType == EVNSnsOAuthAlipay) {
    [self aliAuth:params block:commpletion];
  } else if (oAuthType == EVNSnsOAuthWeibo) {
    [self weiboAuth:params block:commpletion];
  } else if (oAuthType == EVNSnsOAuthQQ) {
    [self qqAuth:params block:commpletion];
  }
}

- (void)qqAuth:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion {
  self.commpletion = commpletion;
  [[EVNQQManager defaultManager] authorize];
}

- (void)wxAuth:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion {
  self.commpletion = commpletion;
  //构造SendAuthReq结构体
  SendAuthReq* req =[[SendAuthReq alloc] init];
  req.scope = @"snsapi_userinfo" ;
  req.state = [NSString stringWithFormat:@"wechat.oauth.%03lu",(unsigned long)[NSDate date].timeIntervalSince1970];//请求随机数
  
  //第三方向微信终端发送一个SendAuthReq消息结构
  [[EVNWXManager defaultManager] sendReq:req completion:^(BOOL success) {
    if (!success) {
      commpletion(@"-3", [NSError errorWithDomain:@"snsOAuth" code:-3 userInfo:@{NSLocalizedDescriptionKey : @"check image size or other params"}]);
      self.commpletion = nil;
    }
  }];
}

- (void)weiboAuth:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion {
  self.commpletion = commpletion;
  NSString *redirectURL = [EVNWeiboManager defaultManager].redirectUrl;
  WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
  authRequest.redirectURI = redirectURL;
  authRequest.scope = @"all";
  
  BOOL success = [[EVNWeiboManager defaultManager] sendRequest:authRequest];
  if (!success) {
    commpletion(@"-3", [NSError errorWithDomain:@"snsOAuth" code:-3 userInfo:@{NSLocalizedDescriptionKey : @"check image size or other params"}]);
    self.commpletion = nil;
  }
}

- (void)aliAuth:(NSDictionary *)params block:(void(^)(NSString *code, NSError *error))commpletion {

  void (^alipay_block)(NSDictionary *resultDic) = ^(NSDictionary *resultDic) {
    NSString *resultStr = resultDic[@"result"];
    
    if ([resultStr length] == 0) {
      /*
       9000
       请求处理成功
       4000
       系统异常
       6001
       用户中途取消
       6002
       ￼网络连接出错
       */
      NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
      NSString *msg = @"用户取消授权";
      switch (resultStatus) {
        case 4000:
          msg = @"系统异常";
          break;
        case 0:
        case 6001:
          msg = @"用户中途取消";
          break;
        case 6002:
          msg = @"网络连接出错";
          break;
        default:
          msg = @"支付宝异常";
          break;
      }
      commpletion(@"-1", [NSError errorWithDomain:@"snsOAuth" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:msg}]);
      return ;
    }
    
    @autoreleasepool {
      NSArray *fragments = [resultStr componentsSeparatedByString:@"&"];
      NSMutableDictionary *dic = [NSMutableDictionary dictionary];
      for (NSString *str in fragments) {
        NSArray *comps = [str componentsSeparatedByString:@"="];
        if ([comps count] != 2) {
          continue ;
        }
        [dic setObject:comps[1] forKey:comps[0]];
      }
      
      
      NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\""];
      NSString *authCode = [[dic objectForKey:@"auth_code"] stringByTrimmingCharactersInSet:set];
      
      if (authCode) {
        commpletion(authCode, nil);
      }
      else {//描述不知道key
        /*
         200
         业务处理成功,会返回 authCode
         1005
         账户已冻结,如有疑问,请联系支付宝技术支持
         713
         userId 不能转换为 openId,请联系支付宝技术支持
         202
         系统异常,请联系支付宝技术支持
         */
        NSInteger result_code = [dic[@"result_code"] integerValue];
        NSString *msg = @"用户取消授权";
        switch (result_code) {
          case 1005:
            msg = @"账户已冻结,如有疑问,请联系支付宝技术支持";
            break;
          case 713:
            msg = @"userId 不能转换为 openId,请联系支付宝技术支持";
            break;
          case 202:
            msg = @"系统异常,请联系支付宝技术支持";
            break;
          default:
            msg = @"支付宝异常";
            break;
        }
        commpletion(nil,[NSError errorWithDomain:@"snsOAuth" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:msg}]);
      }
    }
    
  };
  
  NSString *loginAuthLink = [params valueForKey:@"authLink"];
  NSString *scheme = [params valueForKey:@"scheme"];
  [[EVNAliManager defaultManager] authWithInfo:loginAuthLink scheme:scheme  callback:alipay_block];
}

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(SendAuthReq *)req {
  NSLog(@"微信登录请求已经发出[%@]",req.state);
}

- (void)onQQReq:(QQBaseReq *)req {
  
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(SendAuthResp*)resp {
  if (!self.commpletion) {
    return;
  }
  //得到code后，返回结果
  if ([resp.code length] > 0) {
    
    self.commpletion(resp.code, nil);
  }
  else {//用户取消授权
    self.commpletion(nil,[NSError errorWithDomain:@"snsOAuth" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"用户取消授权"}]);
  }
  self.commpletion = nil;
}

#pragma mark - SinaWeiboRequest Delegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
  if ([response isKindOfClass:WBAuthorizeResponse.class]) {
    NSString *code = [NSString stringWithFormat:@"%@", @(response.statusCode)];
    WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
    
    // 传递给后台，让后台解析
    NSString *result = [NSString stringWithFormat:@"user_id=%@&access_token=%@&expiration_date=%@&refresh_token=%@",authResponse.userID, authResponse.accessToken, authResponse.expirationDate, authResponse.refreshToken];
    
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
      self.commpletion(result, nil);
    } else {
      self.commpletion(code, [NSError errorWithDomain:@"snsOAuth" code:response.statusCode userInfo:nil]);
    }
    
    self.commpletion = nil;
  }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
  
}

- (void)onQQResp:(QQBaseResp *)resp {
  if (!self.commpletion) {
    return;
  }
  
  if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
    if (!resp.errorDescription) {
      self.commpletion(resp.result, nil);
    } else {
      self.commpletion(nil, [NSError errorWithDomain:@"share" code:-10 userInfo:nil]);;
    }
  }
  
  self.commpletion = nil;
}

@end
