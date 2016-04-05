//
//  JSPatchTool.h
//  TomatoClock
//
//  Created by huxiaoqiao on 16/3/28.
//  Copyright © 2016年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSPatch/JSPatch.h>
#import <JSPatch/JPEngine.h>


@interface JSPatchTool : NSObject

+ (void)startWithAppKey:(NSString *)aAppKey;
+ (void)sync;
+ (void)testScriptInBuddle;
@end
