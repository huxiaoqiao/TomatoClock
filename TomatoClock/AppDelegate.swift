//
//  AppDelegate.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/11/28.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let completeCategory = "COMPLETE_CATEGORY"
    let restCategory = "REST_COMPLETE_CATEGORY"
    let restCompleteCategory = "REST_COMPLETE_CATEGORY"
    let timerCurrentStateKey = "timerCurrentStateKey"
    let timerFireDateKey = "timerFireDate"

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //开启JSPatch补丁服务
        JSPatchTool.startWithAppKey(JSPatchAPPKey)
        JSPatchTool.sync()
//        JSPatchTool.testScriptInBuddle()
        
        localNotificationConfig(application)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        
        //注册ShareSDK
        ShareSDKTool.registerApp(ShareSDKAppKey)
        
        
        
        return true
    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        saveTimerAndNotification()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        loadTimer()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
    
    }
    
    //MARK: - handle action
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        application.applicationIconBadgeNumber = 0
        let myTimer = Timer.sharedInstance
        
        if let identifier = identifier {
            switch identifier {
            case "completeRemindRater":
                let remindRaterNotification = setNotification("已再工作5分钟", timeToNotification: 5 * 60, soundName: "", category: completeCategory)
                application.scheduleLocalNotification(remindRaterNotification)
            case "relaxNow":
                myTimer.timerCurrentState = timerState.rest
                myTimer.fireDate = NSDate(timeIntervalSinceNow: Double(myTimer.restFireTime))
                myTimer.currentTime = Int(myTimer.fireDate.timeIntervalSinceDate(NSDate(timeIntervalSinceNow: 0)))
                
                let restNotification = setNotification("时间到了,休息完毕", timeToNotification: Double(myTimer.restFireTime), soundName: "", category: restCompleteCategory)
                application.scheduleLocalNotification(restNotification)
                
            case "restRemindRater":
                let remindRaterNotification = setNotification("已再休息5分钟", timeToNotification: 5 * 60, soundName: "", category: restCategory)
                application.scheduleLocalNotification(remindRaterNotification)
            case "workingNow":
                myTimer.timerCurrentState = timerState.start
                myTimer.fireDate = NSDate(timeIntervalSinceNow: Double(myTimer.fireTime))
                myTimer.currentTime = Int(myTimer.fireDate.timeIntervalSinceDate(NSDate(timeIntervalSinceNow: 0)))
                
                let completeNotification = setNotification("时间到了,已完成任务", timeToNotification: Double(myTimer.fireTime), soundName: "", category: completeCategory)
                application.scheduleLocalNotification(completeNotification)
            default:
                print("error :\(identifier)")
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(myTimer.timerCurrentState, forKey: timerCurrentStateKey)
        NSUserDefaults.standardUserDefaults().setObject(myTimer.fireDate, forKey: timerFireDateKey)
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        completionHandler()
        
    }
    
    
    //URL scheme
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return true
    }
    
    //MARK: - 微信必须
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: nil)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpenURL(url, delegate: nil)
    }
    
}

extension AppDelegate{
    func localNotificationConfig(application:UIApplication) {
        //MARK: - Notification Action
        let notificationActionOK:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionOK.identifier = "completeRemindRater"
        notificationActionOK.title = "再工作一会儿"
        notificationActionOK.destructive = false
        notificationActionOK.authenticationRequired = false
        notificationActionOK.activationMode = .Background
        
        let notificationActionRestNow:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionRestNow.identifier = "relaxNow"
        notificationActionRestNow.title = "休息"
        notificationActionRestNow.destructive = false
        notificationActionRestNow.authenticationRequired = false
        notificationActionRestNow.activationMode = .Background
        
        let notificationActionRest:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionRest.identifier = "restRemindRater"
        notificationActionRest.title = "再休息一会儿"
        notificationActionRest.destructive = false
        notificationActionRest.authenticationRequired = false
        notificationActionRest.activationMode = .Background
        
        let notificationActionWorking:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionWorking.identifier = "workingNow"
        notificationActionWorking.title = "工作"
        notificationActionWorking.destructive = false
        notificationActionWorking.authenticationRequired = false
        notificationActionWorking.activationMode = .Background
        
        //MARK: - Notification Category
        let notificationCompleteCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationCompleteCategory.identifier = completeCategory
        notificationCompleteCategory.setActions([notificationActionOK,notificationActionRestNow], forContext: .Default)
        notificationCompleteCategory.setActions([notificationActionOK,notificationActionRestNow], forContext: .Minimal)
        
        let notificationRestCompletCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationRestCompletCategory.identifier = restCategory
        notificationRestCompletCategory.setActions([notificationActionRest,notificationActionWorking], forContext: .Default)
        notificationRestCompletCategory.setActions([notificationActionRest,notificationActionWorking], forContext: .Minimal)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound,.Alert,.Badge], categories: NSSet(array: [notificationCompleteCategory,notificationRestCompletCategory]) as? Set<UIUserNotificationCategory>))
        
    }
    
    func loadTimer(){
        let fireDate = NSUserDefaults.standardUserDefaults().objectForKey(timerFireDateKey) as? NSDate
        let currentState = NSUserDefaults.standardUserDefaults().objectForKey(timerCurrentStateKey) as? String
        if fireDate == nil || currentState == nil {
            return
        }
        
        let timeInterval = Int(fireDate!.timeIntervalSinceDate(NSDate(timeIntervalSinceNow: 0)))
        if timeInterval > 0 {
            Timer.sharedInstance.currentTime = timeInterval
            Timer.sharedInstance.timerCurrentState = currentState!
            Timer.sharedInstance.timerAction()
        }else{
            Timer.sharedInstance.currentTime = 0
        }
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        
    }
    
    func saveTimerAndNotification(){
        let timer = Timer.sharedInstance
        if timer.fireDate == nil {
            return
        }
        let restTime = timer.fireDate.timeIntervalSinceDate(NSDate(timeIntervalSinceNow: 0))
        NSUserDefaults.standardUserDefaults().setObject(timer.fireDate, forKey: timerFireDateKey)
        NSUserDefaults.standardUserDefaults().setObject(timer.timerCurrentState, forKey: timerCurrentStateKey)
        if restTime < 0 {
            return
        }

        if timer.timerCurrentState == timerState.start {
            let completeNotification = setNotification("时间到了，已完成任务",timeToNotification: restTime,soundName: "",category: completeCategory)
            UIApplication.sharedApplication().scheduleLocalNotification(completeNotification)
        }else if timer.timerCurrentState == timerState.rest{
            let restNotification = setNotification("时间到了，休息完毕",timeToNotification: restTime,soundName: "",category: restCompleteCategory)
            UIApplication.sharedApplication().scheduleLocalNotification(restNotification)
        }else{
            print("current state:\(timer.timerCurrentState)")
        }
        
        
    }
    
}


