//
//  TomatoViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/12/2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit

class TomatoViewController: UIViewController {
    
    var taskTitle:String?
    
    @IBOutlet weak var stopButton: UIButton!                 //停止按钮
    @IBOutlet weak var circularProgress: KYCircularProgress! //圆形进度条
    @IBOutlet weak var trickView: UIView!                    //圆形轨道
    @IBOutlet weak var taskTitleLabel: UILabel!              //任务标题
    @IBOutlet weak var tomatoStateLabel: UILabel!            //状态标题
    @IBOutlet weak var countButton: UIButton!                //计数按钮
    @IBOutlet weak var revealView: UIView!                   //动画view
    
    var tomatoTime:Double!
    var progress: Int = 0
    var shapeLayer:CAShapeLayer!
    var timer:NSTimer!
    let myTimer = Timer.sharedInstance
    var ripplesLayer:DWRipplesLayer = DWRipplesLayer()
    
    /*********MARK -- Life cirle ************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化UI元素
        self.initUIElements()
        myTimer.fireTime = Int(tomatoTime)
        myTimer.timerWillState = timerState.start
        myTimer.delegate = self
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        UIView.setAnimationsEnabled(false)
        //开始计时
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
        circularProgress.progress = 1.0
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
        
        let backView:UIView = UIView()
        backView.bounds = CGRectMake(0, 0, 270, 270)
        backView.layer.cornerRadius = 135
        backView.center = trickView.center
        backView.backgroundColor = self.view.backgroundColor
        self.view.insertSubview(backView, belowSubview: countButton)
        
        
        //ripplesLayer
        self.view.layer .insertSublayer(self.ripplesLayer, below: backView.layer)
        self.ripplesLayer.position = trickView.center
        self.ripplesLayer.radius = 280
        self.ripplesLayer.animationDuration = 4.0
        
        self.view .bringSubviewToFront(countButton)
        
        countButton.setTitle(formatToDisplayTime(Int(tomatoTime)), forState: .Normal)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TomatoViewController.updateProgress), userInfo: nil, repeats: true)
    }
    
    /**
    更新进度条
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
        let times = getTimeSetting()
        let tomatoNum:Int = getTomatoNum().tomatoNum
        if (tomatoNum != 0 && tomatoNum % 4 == 0)
        {
           rest.tomatoTime = Double(times.longrestTime * 60)
        }else
        {
            rest.tomatoTime = Double(times.shortrestTime * 60)
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
        if UIView.areAnimationsEnabled() == true {
            UIView.setAnimationsEnabled(false)
        }
        if currentTime == 0 {
            UIView.setAnimationsEnabled(true)
            tomatoStateLabel.hidden = true
            countButton.setTitle("开始休息", forState: .Normal)
            countButton.titleLabel?.font = UIFont.systemFontOfSize(36)
            countButton.enabled = true
            circularProgress.progress = 0
            self.ripplesLayer.startAnimation()
        }else{
            //print(currentTime)
            countButton.setTitle(formatToDisplayTime(currentTime), forState: .Normal)
            let normalizedProgress = Double(currentTime - 1 ) / tomatoTime
            circularProgress.progress = normalizedProgress
            
        }
    }
 
    
}



