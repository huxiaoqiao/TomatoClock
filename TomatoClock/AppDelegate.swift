//
//  AppDelegate.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/11/28.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //保证程序进入后台后仍运行定时器
        var setCategoryErr:NSError? = nil
        var activationErr:NSError? = nil
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: &setCategoryErr)
        AVAudioSession.sharedInstance().setActive(true, error: &activationErr)
        
        ShareSDK.registerApp(ShareSDKAppKey)
        
        //添加新浪微博应用
        ShareSDK.connectSinaWeiboWithAppKey(WeiBoAppKey, appSecret: WeiBoAppSecret, redirectUri: "http://user.qzone.qq.com/1766862099/blog/1427178992")
        
        //添加微信应用
        ShareSDK.connectWeChatWithAppId(WeiChatAppId, appSecret: WeiChatAppSecret, wechatCls: WXApi.classForCoder())
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        var app:UIApplication = UIApplication.sharedApplication()
        
        var bgTask:UIBackgroundTaskIdentifier?
        
        bgTask = app.beginBackgroundTaskWithExpirationHandler({ () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(bgTask != UIBackgroundTaskInvalid){
                    bgTask = UIBackgroundTaskInvalid
                }
            })
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            if(bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid
            }
        })
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //MARK: - 微信必须
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return ShareSDK.handleOpenURL(url, wxDelegate: self)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return ShareSDK.handleOpenURL(url, sourceApplication: sourceApplication, annotation: annotation, wxDelegate: self)
    }
    
    
}

