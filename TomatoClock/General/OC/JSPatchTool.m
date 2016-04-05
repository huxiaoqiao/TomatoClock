//
//  JSPatchTool.m
//  TomatoClock
//
//  Created by huxiaoqiao on 16/3/28.
//  Copyright © 2016年 胡晓桥. All rights reserved.
//

#import "JSPatchTool.h"

@implementation JSPatchTool

+ (void)startWithAppKey:(NSString *)aAppKey
{
    [JSPatch startWithAppKey:aAppKey];
}
+ (void)sync
{
    [JSPatch sync];
}
+ (void)testScriptInBuddle
{
    [JSPatch testScriptInBundle];
}

@end
