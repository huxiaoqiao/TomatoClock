//
//  ShowShareSDK.h
//  TomatoClock
//
//  Created by 胡晓桥 on 15/3/17.
//  Copyright (c) 2015年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

#import "DismissingAnimator.h"
#import "PresentingAnimator.h"
#import <ShareSDKUI/ShareSDKUI.h>

@interface ShowShareSDK : NSObject

//- (void)showShareSDK:(id<ISSContainer>) container content:(id<ISSContent>)content;

- (id)dismissingAnimator;
- (id)presentingAnimator;

@end
