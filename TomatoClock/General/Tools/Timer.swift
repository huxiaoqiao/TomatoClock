//
//  Timer.swift
//  TomatoClock
//
//  Created by huxiaoqiao on 16/4/22.
//  Copyright © 2016年 胡晓桥. All rights reserved.
//
import Foundation
import UIKit

protocol TimerDelegate {
    func updateingTime(currentTime:Int)
    func timerStateToController(timerWillState:String)
}


class Timer: NSObject {
    
    var timerCurrentState = timerState.giveUp
    var fireTime = 25 * 60
    var restFireTime = 5 * 60
    var duractionTime = 25 * 60
    var fireDate:NSDate!
    var currentTime = 25 * 60
    var timer:NSTimer!
    var timerWillState = timerState.start
    
    var delegate:TimerDelegate?
    
    static var sharedInstance = Timer()
    
    override init() {
        //set timer
        super.init()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(Timer.timeCount(_:)), userInfo: nil, repeats: true)
    }
    
    func timerAction(){
        switch timerCurrentState {
        case timerState.giveUp:
            print("Give up")
        case timerState.start:
            //set timer
            delegate?.timerStateToController(timerState.giveUp)
            timerWillState = timerState.giveUp
            print("starting")
        case timerState.rest:
            delegate?.timerStateToController(timerState.giveUp)
            timerWillState = timerState.giveUp
            print("resting")
        default:
            print("error:\(timerCurrentState)")
        }
    }
    
    func timerWillAction(){
        switch timerWillState {
        case timerState.start:
            timerCurrentState = timerState.start
            currentTime = fireTime
            
            //set fire Date
            fireDate = NSDate(timeIntervalSinceNow: Double(fireTime))
            delegate?.timerStateToController(timerState.giveUp)
            timerWillState = timerState.giveUp
            break;
        case timerState.giveUp:
            self.currentTime = fireTime
            self.timerCurrentState = timerState.giveUp
            delegate?.timerStateToController(timerState.start)
            timerWillState = timerState.start
            break;
        case timerState.rest:
            timerCurrentState = timerState.rest
            // set fireDate
            fireDate = NSDate(timeIntervalSinceNow: Double(restFireTime))
            // set timer
             currentTime = restFireTime
            
            delegate?.timerStateToController(timerState.giveUp)
            
            timerWillState = timerState.giveUp
            break;
        case timerState.workingComplete:
            delegate?.timerStateToController(timerState.workingComplete)
            timerWillState = timerState.rest
            duractionTime = restFireTime
            break;
        case timerState.restComplete:
            delegate?.timerStateToController(timerState.restComplete)
            
            timerWillState = timerState.start
            duractionTime = fireTime
            break;
        default:
            print("not have this timerState \(timerWillState)")
        }
    }
    
    func timeCount(timer:NSTimer){
        if timerCurrentState == timerState.giveUp {
            return
        }
        
        delegate?.updateingTime(currentTime)
        
        if currentTime > 0 {
            currentTime -= 1
            
        }else if timerCurrentState == timerState.start{
            timerCurrentState = timerState.giveUp
            timerWillState = timerState.workingComplete
            timerWillAction()
        }else if timerCurrentState == timerState.rest{
            timerCurrentState = timerState.giveUp
            timerWillState = timerState.restComplete
            timerWillAction()
        }
        
    }
    
    
    
}
