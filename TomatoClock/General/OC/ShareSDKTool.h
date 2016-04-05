//
//  ShareSDKTool.h
//  TomatoClock
//
//  Created by huxiaoqiao on 16/3/29.
//  Copyright © 2016年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "DismissingAnimator.h"
#import "PresentingAnimator.h"

@interface ShareSDKTool : NSObject

+ (void)registerApp:(NSString *)appKey;

+ (void)showShareActionSheet;


- (id)dismissingAnimator;
- (id)presentingAnimator;

@end
