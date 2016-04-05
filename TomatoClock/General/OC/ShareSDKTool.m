//
//  ShareSDKTool.m
//  TomatoClock
//
//  Created by huxiaoqiao on 16/3/29.
//  Copyright © 2016年 胡晓桥. All rights reserved.
//

#define kWeiBoAppKey @"3614517113"
#define kWeiBoAppSecret @"2a98834f6e87ab6f1e8c3059c13f442c"
#define kAppStoreUrl @"https://itunes.apple.com/cn/app/fan-jia-ji-shi-qi/id979473925?l=en&mt=8"
#define kRedirectUrl @"http://www.sharesdk.cn"
#define kWechatAppId @"wxbc4a7c7eed9591aa"
#define kWechatAppSecret @"ec005edfc05d4194ccccc315b8df5a9d"
#define kQQAppId @"1105217319"
#define kQQAppKey @"fF5JAWpausJdXvh3"

#define kShareText @"番茄时钟帮助您更有效率、更健康的工作或学习!"
#define kShareTitle @"简洁高效的番茄工作法实践工具"

#import "ShareSDKTool.h"

@implementation ShareSDKTool

+ (void)registerApp:(NSString *)appKey{
    [ShareSDK registerApp:appKey activePlatforms:@[
                      @(SSDKPlatformTypeSinaWeibo),
                      @(SSDKPlatformSubTypeWechatSession),
                      @(SSDKPlatformSubTypeWechatTimeline),
                      //@(SSDKPlatformTypeQQ),
                      @(SSDKPlatformTypeSMS)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                          switch(platformType){
                              case SSDKPlatformTypeSinaWeibo:{
                                  //[ShareSDKConnector connectWeibo:[WeiboSDK class]];
                              }
                                  break;
                                  case SSDKPlatformTypeWechat:{
                                      [ShareSDKConnector connectWeChat:[WXApi class]];
                              }
                                  break;
//                              case SSDKPlatformTypeQQ:{
//                                  [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                                  
//                              }
//                                  break;
                            default:break;
                          }
                          
                          
                      } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
                          switch (platformType)
                          {
                              case SSDKPlatformTypeSinaWeibo:
                                  //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                  [appInfo SSDKSetupSinaWeiboByAppKey:kWeiBoAppKey
                                                            appSecret:kWeiBoAppSecret
                                                          redirectUri:kRedirectUrl
                                                             authType:SSDKAuthTypeBoth];
                                  break;
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:kWechatAppId                                                        appSecret:kWechatAppSecret];
                                  break;
//                              case SSDKPlatformTypeQQ:
//                                  [appInfo SSDKSetupQQByAppId:kQQAppId
//                                                       appKey:kQQAppKey
//                                                     authType:SSDKAuthTypeBoth];
//                                  break;
                              default:
                                  break;
                          }
                      }];
}

+ (void)showShareActionSheet{
    //1.创建分享参数
    NSArray *imageArray = @[[UIImage imageNamed:@"ShareImage"]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:kShareText images:imageArray url:[NSURL URLWithString:kAppStoreUrl] title:kShareTitle type:SSDKContentTypeAuto];
        //定制新浪微博分享内容
        NSArray *detailImgs = @[[UIImage imageNamed:@"screen_crop_1"],[UIImage imageNamed:@"screen_crop_2"]];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:kShareText title:kShareTitle image:detailImgs url:[NSURL URLWithString:kAppStoreUrl] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        [shareParams SSDKSetupSMSParamsByText:kShareText title:kShareTitle images:imageArray attachments:nil recipients:nil type:SSDKContentTypeAuto];
        //[shareParams SSDKSetupQQParamsByText:kShareText title:kShareTitle url:[NSURL URLWithString:kAppStoreUrl] thumbImage:imageArray image:detailImgs type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformTypeQQ];
        
        
        //弹出分享视图
       SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil items:@[@(SSDKPlatformTypeWechat),/*@(SSDKPlatformTypeQQ),*/@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeSMS)] shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                    
                case SSDKResponseStateSuccess: {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                        message:nil
                        delegate:nil
                        cancelButtonTitle:@"确定"
                        otherButtonTitles:nil];
                    [alertView show];
                    break;
                    
                }
                    break;
                case SSDKResponseStateFail: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error]
                        delegate:nil
                        cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil];
                    [alert show];
                }
                    break;
                default: break;
            }
        }];
        
        //新浪微博和短信不跳分享编辑界面
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSMS)];
    }
    
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
