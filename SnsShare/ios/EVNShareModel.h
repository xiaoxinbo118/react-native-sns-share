//
//  EVNShareModel.h
//  EVNShare
//
//  Created by Evan Xiao on 9/11/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  EVNSnsShareWeChatMini,
  EVNSnsShareWeChatSession,
  EVNSnsShareWeChatTimeline,
  EVNSnsShareQQSession,
  EVNSnsShareWeibo,
} EVNSnsShareType;

typedef enum {
  ShareSnsModeWebPage,
  ShareSnsModeImage
} EVNSnsShareMode;

@interface EVNShareModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *webPageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, assign) EVNSnsShareType type;

@end
