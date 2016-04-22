//
//  TomatoViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/12/2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit
import AVFoundation

class TomatoViewController: UIViewController {
    
    
    var taskTitle:String?
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width
    
    @IBOutlet weak var stopButton: UIButton!                 //停止按钮
    @IBOutlet weak var circularProgress: KYCircularProgress! //圆形进度条
    @IBOutlet weak var trickView: UIView!                    //圆形轨道
    @IBOutlet weak var taskTitleLabel: UILabel!              //任务标题
    @IBOutlet weak var tomatoStateLabel: UILabel!            //状态标题
    @IBOutlet weak var countButton: UIButton!                //计数按钮
    @IBOutlet weak var revealView: UIView!                   //动画view
    
    var tomatoTime:Double!
    var progress: Int = 0
    var minute:Int!
    var second:Int!
    var shapeLayer:CAShapeLayer!
    var sShapeLayer:CAShapeLayer!
    var timer:NSTimer!
    var vibrateTimer:NSTimer!
    var pathTimer:NSTimer!
    var player:AVAudioPlayer!
    let myTimer = Timer.sharedInstance
    
    /*********MARK -- Life cirle ************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化UI元素
        self.initUIElements()
        
        myTimer.delegate = self
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        myTimer.timerWillAction()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if event == nil {
            return
        }
        //后台播放音乐
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(true)
        
        UIApplication.sharedApplication().resignFirstResponder()
        
        if(timer != nil)
        {
            timer .invalidate()
            timer = nil
        }
        
        if(vibrateTimer != nil)
        {
            vibrateTimer.invalidate()
            vibrateTimer = nil
        }
        
        if(pathTimer != nil){
            pathTimer.invalidate()
            pathTimer = nil
        }
        if(getRingSwitch() == true){
           //停止播放
            if(player != nil)
            {
                player.stop()
                player = nil
            }
        }

    }
    
    /*********MARK -- Life cirle End************/
    
    /*********MARK -- Private Method ************/

    func initUIElements(){
        taskTitleLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("TaskTitle") as? String
        
        stopButton.layer.cornerRadius = 30 * SCREEN_WIDTH / 320.0;
        stopButton.layer.borderWidth = 0.5
        stopButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        circularProgress.colors = [0xffffff,0xffffff]
        circularProgress.lineWidth = 10
        self.view.addSubview(circularProgress)
        
        trickView.layer.borderColor = UIColor(white: 255, alpha: 0.2).CGColor
        trickView.layer.borderWidth = 10
        trickView.layer.cornerRadius = 135
        trickView.userInteractionEnabled = false
        
        countButton.layer.cornerRadius = 125
        countButton.layer.borderWidth = 0.5
        countButton.layer.borderColor = UIColor.clearColor().CGColor
        countButton.enabled = false
        
        //revealView
        revealView.layer.cornerRadius = 140
        
        if (Int(tomatoTime) % 60 < 10)
        {
            countButton.setTitle("\(Int(tomatoTime) / 60):0\(Int(tomatoTime) % 60)", forState: .Normal)
            
        }else
        {
            countButton.setTitle("\(Int(tomatoTime) / 60):\(Int(tomatoTime) % 60)", forState: .Normal)
        }

    }
    
    /**
    更新定时器
    */
    func updateProgress(){
        progress += 1
        let normalizedProgress = Double(progress) / 5.0
        circularProgress.progress = normalizedProgress
        
        if (circularProgress.progress > 1.0)
        {
            timer.invalidate()
            timer = nil
            circularProgress.progress = 1.0
        }
        if (timer == nil)
        {
            UIView.setAnimationsEnabled(false)
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(TomatoViewController.startTomato), userInfo: nil, repeats: true)
            progress = Int(tomatoTime)
        }
    }
    
    /**
    开始计时
    */
    func startTomato(){
        print("\(progress)")
        progress -= 1
        let normalizedProgress = Double(progress) / tomatoTime
        
        if (circularProgress.progress == 0)
        {
            timer.invalidate()
            timer = nil
            UIView.setAnimationsEnabled(true)
            tomatoStateLabel.hidden = true
            countButton.setTitle("开始休息", forState: .Normal)
            countButton.titleLabel?.font = UIFont.systemFontOfSize(30.0)
            countButton.enabled = true
            
            self.view .bringSubviewToFront(countButton)
        }
        circularProgress.progress = normalizedProgress
        minute = progress / 60
        second = progress % 60
        let minuteStr = minute >= 10 ? "\(minute)":"0\(minute)"
        let secondStr = second >= 10 ? "\(second)":"0\(second)"
        if second >= 0
        {
            countButton.setTitle("\(minuteStr):\(secondStr)", forState: .Normal)
            
        }
    }

    /**
    Navigation Segue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    /**
    开始休息
    :param: sender UIButton
    */
    @IBAction func startRest(sender: UIButton) {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let rest = mainSB.instantiateViewControllerWithIdentifier("RestViewController") as! RestViewController
        let conguration = getConguration()
        let tomatoNum:Int = getTomatoNum().tomatoNum
        if (tomatoNum != 0 && tomatoNum % 4 == 0)
        {
           rest.tomatoTime = Double(conguration.longrestTime * 60)
        }else
        {
            rest.tomatoTime = Double(conguration.shortrestTime * 60)
        }
        //休息次数加一
        var restNum = getTomatoNum().restNum
        restNum += 1
        saveTomatoAndRestNum(tomatoNum, restNum: restNum)
        
        rest.taskTitle = taskTitle
        self.presentViewController(rest, animated: true, completion: { () -> Void in
            self.removeFromParentViewController()
        })
    }
    
    //停止番茄钟
    @IBAction func stop(sender: AnyObject) {
        
        //番茄数减一
        var tomatoNum = getTomatoNum().tomatoNum
        let restNum = getTomatoNum().restNum
        tomatoNum -= 1
        saveTomatoAndRestNum(tomatoNum, restNum: restNum)
    }
    
}


extension TomatoViewController:TimerDelegate{
    
    func timerStateToController(timerWillState: String) {
        switch timerWillState {
        case timerState.start:
            self.countButton.setTitle(formatToDisplayTime(self.myTimer.fireTime), forState: .Normal)
            //FIX:
        default:
            print("error : \(timerWillState)")
        }
    }
    func updateingTime(currentTime: Int) {
        countButton.setTitle(formatToDisplayTime(currentTime), forState: .Normal)
    }
    
}



