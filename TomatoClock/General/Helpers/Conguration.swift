//
//  Conguration.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/12/5.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit
import AudioToolbox


class Conguration: NSObject {
    
    
    class func saveConguration(workTime:Int,shortrestTime:Int,longrestTime:Int){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(workTime, forKey: "workTime")
        userDefaults.setInteger(shortrestTime, forKey: "shortrestTime")
        userDefaults.setInteger(longrestTime, forKey: "longrestTime")
        
    }
    
    class func getConguration() -> (workTime:Int,shortrestTime:Int,longrestTime:Int){
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
    
    class func postNotification(){
        NSNotificationCenter.defaultCenter().postNotificationName("congurationChanged", object: nil)
    }
    
    class func saveTaskTitle(title:String){
        NSUserDefaults.standardUserDefaults().setObject(title, forKey: "TaskTitle");
    }
    
   
    
    //MARK: - 振动相关
    class func setVibrateSwitch(isOn:Bool){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(isOn, forKey: "vibrateSwitch")
        userDefaults.setBool(true, forKey: "isSetVibrate")
    }
    
    class func getVibrateSwitch() ->Bool {
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
    class func setRingSwitch(isOn:Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(isOn, forKey: "ringSwitch")
        userDefaults.setBool(true, forKey: "isSetRing")
    }
    
    class func getRingSwitch() ->Bool {
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
    
    class func setRingTypeAndSelectRow(row:Int,ringType:String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setInteger(row, forKey: "selectRow")
        userDefaults.setObject(ringType, forKey: "ringType")
    }
    
    class func getRingSelectRow() -> (row:Int,ringType:String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let row:Int =  userDefaults.integerForKey("selectRow")
        var ringType:String? = userDefaults.stringForKey("ringType")
        if(ringType == nil){
            ringType = "Alarm"
        }
        return (row,ringType!)
    }
    
    //MARK: - 保存番茄钟的个数：连续4个番茄钟一次长休息
    class func saveTomatoAndRestNum(tomatoNum:Int,restNum:Int){
        let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setInteger(tomatoNum, forKey: "tomatoNum")
        userDefaults.setInteger(restNum, forKey: "restNum")
    }
    
    class func getTomatoNum()-> (tomatoNum:Int,restNum:Int){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var tomatoNum = userDefaults.integerForKey("tomatoNum")
        var restNum = userDefaults.integerForKey("restNum")
        return (tomatoNum,restNum)
    }
    
    
}
