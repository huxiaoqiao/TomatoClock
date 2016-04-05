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
        
        //开启JSPatch补丁服务
        JSPatchTool.startWithAppKey(JSPatchAPPKey)
        JSPatchTool.sync()
        
        //保证程序进入后台后仍运行定时器
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        try! session.setActive(true)
        
        //注册ShareSDK
        ShareSDKTool.registerApp(ShareSDKAppKey)
    
        
        
        return true
    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        
         }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        let app:UIApplication = UIApplication.sharedApplication()
        
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
        
     
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
    
    }
    
    
    //MARK: - 微信必须
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: nil)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpenURL(url, delegate: nil)
    }
    
    
    
}

