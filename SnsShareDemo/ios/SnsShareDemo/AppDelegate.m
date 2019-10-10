/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "EVNAliManager.h"
#import "EVNWeiboManager.h"
#import "EVNWXManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"SnsShareDemo"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  BOOL handled = NO;
  
  handled = [EVNWeiboManager.defaultManager application:app openURL:url];
  
  if (handled) {
    return YES;
  }
  
  handled = [EVNAliManager.defaultManager application:app openURL:url];
  
  if (handled) {
    return YES;
  }
  
  handled = [EVNWXManager.defaultManager application:app openURL:url];
  
  if (handled) {
    return YES;
  }
  
  return handled;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  [[EVNWeiboManager defaultManager] applicationWillEnterForeground:application];
  [[EVNWXManager defaultManager] applicationWillEnterForeground:application];
  [[EVNAliManager defaultManager] applicationWillEnterForeground:application];
}

@end
