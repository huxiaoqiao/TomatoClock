//
//  ShowShareSDK.m
//  TomatoClock
//
//  Created by 胡晓桥 on 15/3/17.
//  Copyright (c) 2015年 胡晓桥. All rights reserved.
//

#import "ShowShareSDK.h"


@implementation ShowShareSDK


- (id)dismissingAnimator
{
    return [DismissingAnimator new];
}
- (id)presentingAnimator
{
    return [PresentingAnimator new];
}

@end
