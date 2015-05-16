//
//  ShowShareSDK.m
//  TomatoClock
//
//  Created by 胡晓桥 on 15/3/17.
//  Copyright (c) 2015年 胡晓桥. All rights reserved.
//

#import "ShowShareSDK.h"


@implementation ShowShareSDK

- (void)showShareSDK:(id<ISSContainer>) container content:(id<ISSContent>)content
{

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:content
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"shareSuccess" object:nil];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
}

- (id)dismissingAnimator
{
    return [DismissingAnimator new];
}
- (id)presentingAnimator
{
    return [PresentingAnimator new];
}

@end
