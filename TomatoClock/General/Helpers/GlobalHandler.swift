//
//  swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/12/5.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit
import AudioToolbox

let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.size.height

struct timerState {
    static let start = "开始"
    static let giveUp = "放弃"
    static let workingComplete = "完成工作"
    static let restComplete = "休息完了"
    static let rest = "休息"
    static let updating = "时间更新中"
}


func setNotification(body:String,timeToNotification:Double,soundName:String,category:String) -> UILocalNotification{
    let localNotification:UILocalNotification = UILocalNotification()
    localNotification.alertAction = "滑动查看信息"
    localNotification.applicationIconBadgeNumber = 0
    localNotification.alertBody = body
    localNotification.soundName = soundName
    localNotification.fireDate = NSDate(timeIntervalSinceNow: timeToNotification)
    localNotification.category = category
    localNotification.applicationIconBadgeNumber = 1
    return localNotification
}

func formatToDisplayTime(currentTime:Int) -> String{
    let min = currentTime / 60
    let second = currentTime % 60
    let time = String(format: "%02d:%02d", argumentrs:[min,second])
    return time
}


func saveConguration(workTime:Int,shortrestTime:Int,longrestTime:Int){
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setInteger(workTime, forKey: "workTime")
    userDefaults.setInteger(shortrestTime, forKey: "shortrestTime")
    userDefaults.setInteger(longrestTime, forKey: "longrestTime")
    
}

func getConguration() -> (workTime:Int,shortrestTime:Int,longrestTime:Int){
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let workTime = userDefaults.integerForKey("workTime")
    let shortrestTime = userDefaults.integerForKey("shortrestTime")
    let longrestTime = userDefaults.integerForKey("longrestTime")
    
    if (workTime == 0 || shortrestTime == 0 || longrestTime == 0)
    {
        return (25,5,20)
    }
    
    return (workTime,shortrestTime,longrestTime)
}

func postNotification(){
    NSNotificationCenter.defaultCenter().postNotificationName("congurationChanged", object: nil)
}

func saveTaskTitle(title:String){
    NSUserDefaults.standardUserDefaults().setObject(title, forKey: "TaskTitle");
}



//MARK: - 振动相关
func setVibrateSwitch(isOn:Bool){
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setBool(isOn, forKey: "vibrateSwitch")
    userDefaults.setBool(true, forKey: "isSetVibrate")
}

func getVibrateSwitch() ->Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var isOn:Bool
    if(userDefaults.boolForKey("isSetVibrate") == false)
    {
        isOn = true
    }else
    {
        isOn = userDefaults.boolForKey("vibrateSwitch")
    }
    return isOn
}

//MARK: - 铃声相关
func setRingSwitch(isOn:Bool) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setBool(isOn, forKey: "ringSwitch")
    userDefaults.setBool(true, forKey: "isSetRing")
}

func getRingSwitch() ->Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var isOn:Bool
    if(userDefaults.boolForKey("isSetRing") == false)
    {
        isOn = true
    }else
    {
        isOn = userDefaults.boolForKey("ringSwitch")
    }
    return isOn
}

func setRingTypeAndSelectRow(row:Int,ringType:String) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    userDefaults.setInteger(row, forKey: "selectRow")
    userDefaults.setObject(ringType, forKey: "ringType")
}

func getRingSelectRow() -> (row:Int,ringType:String) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let row:Int =  userDefaults.integerForKey("selectRow")
    var ringType:String? = userDefaults.stringForKey("ringType")
    if(ringType == nil){
        ringType = "Alarm"
    }
    return (row,ringType!)
}

//MARK: - 保存番茄钟的个数：连续4个番茄钟一次长休息
func saveTomatoAndRestNum(tomatoNum:Int,restNum:Int){
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setInteger(tomatoNum, forKey: "tomatoNum")
    userDefaults.setInteger(restNum, forKey: "restNum")
}

func getTomatoNum()-> (tomatoNum:Int,restNum:Int){
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let tomatoNum = userDefaults.integerForKey("tomatoNum")
    let restNum = userDefaults.integerForKey("restNum")
    return (tomatoNum,restNum)
}



