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
    
    /*********MARK -- Life cirle ************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化UI元素
        self.initUIElements()
        
        //指示动画
        let tomato:AnyObject! = UIImage(named: "tomato")
        let tomato_gray:AnyObject! = UIImage(named: "tomato_gray")
        let shortRest:AnyObject! = UIImage(named: "shortrest")
        let shortRest_gray:AnyObject! = UIImage(named: "shortrest_gray")
        let longRest:AnyObject! = UIImage(named: "longrest")
        let longRest_gray:AnyObject! = UIImage(named: "longrest_gray")
        let tomatos = [tomato,tomato_gray]
        let shortRests = [shortRest,shortRest_gray]
        let longRests = [longRest,longRest_gray]
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(true)
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
        if(Conguration.getRingSwitch() == true){
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
    
    func initShapeLayer() {
        shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.view.bounds
        shapeLayer.position = self.view.center
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.lightTextColor().CGColor
        
        shapeLayer.path = self.getBezierPath1().CGPath
        
        sShapeLayer = CAShapeLayer()
        sShapeLayer.bounds = self.view.bounds
        sShapeLayer.position = self.view.center
        sShapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.lightTextColor().CGColor
        
        sShapeLayer.path = self.getBezierPath1().CGPath
        
        self.view.layer.addSublayer(sShapeLayer)
        
        pathTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("pathAnimation"), userInfo: nil, repeats: true)
        
    }
    var count:Int = 0
    func pathAnimation() {
        println("\(count)")
        count++
       
        var radiusAnim = CABasicAnimation(keyPath: "path")
        radiusAnim.removedOnCompletion = true
        radiusAnim.duration = 2.0
        radiusAnim.fromValue = self.getBezierPath1().CGPath
        radiusAnim.toValue = self.getBezierPath2().CGPath
        sShapeLayer.addAnimation(radiusAnim, forKey: "path" )
        //        }
        
        
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
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("startTomato"), userInfo: nil, repeats: true)
            progress = Int(tomatoTime)
        }
    }
    
    /**
    开始计时
    */
    func startTomato(){
        println("\(progress)")
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
            
//            revealView.backgroundColor = UIColor.lightTextColor()
//            
//            let transition = CircularRevealTransition(layer: revealView.layer, center: revealView.center)
//            transition.start()
            
            
            let isVibrateOn = Conguration.getVibrateSwitch()
            if(isVibrateOn == true)
            {
                self.vibrate()
            }
            
            let isRingOn = Conguration.getRingSwitch()
            if(isRingOn == true){
                let urlStr = NSBundle.mainBundle().pathForResource(Conguration.getRingSelectRow().ringType, ofType: "m4r")
                let url = NSURL(fileURLWithPath: urlStr!)
                var error:NSError?
                if(url != nil)
                {
                    
                    player = AVAudioPlayer(contentsOfURL: url, error: &error)
                   
                }else
                {
                    player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Constellation", ofType: "m4r")!), error: &error)
                }
                player.play()
                player.numberOfLoops = 10
            }
            
            self.view .bringSubviewToFront(countButton)
        }
        circularProgress.progress = normalizedProgress
        minute = progress / 60
        second = progress % 60
        var minuteStr = minute >= 10 ? "\(minute)":"0\(minute)"
        var secondStr = second >= 10 ? "\(second)":"0\(second)"
        if second >= 0
        {
            countButton.setTitle("\(minuteStr):\(secondStr)", forState: .Normal)
            
        }
    }
    
    /**
    调用手机振动
    */
    func vibrate() {
        vibrateTimer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: Selector("startVibrate"), userInfo: nil, repeats: true)
        
    }
    func startVibrate(){
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    /**
    Navigation Segue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "checkSegue"){
            var check = segue.destinationViewController as! CheckViewController
        }
        self.removeFromParentViewController()
    }
    
    /**
    开始休息
    :param: sender UIButton
    */
    @IBAction func startRest(sender: UIButton) {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        var rest = mainSB.instantiateViewControllerWithIdentifier("RestViewController") as! RestViewController
        let conguration = Conguration.getConguration()
        let tomatoNum:Int = Conguration.getTomatoNum().tomatoNum
        if (tomatoNum != 0 && tomatoNum % 4 == 0)
        {
           rest.tomatoTime = Double(conguration.longrestTime * 60)
        }else
        {
            rest.tomatoTime = Double(conguration.shortrestTime * 60)
        }
        //休息次数加一
        var restNum = Conguration.getTomatoNum().restNum
        restNum++
        Conguration.saveTomatoAndRestNum(tomatoNum, restNum: restNum)
        
        rest.taskTitle = taskTitle
        self.presentViewController(rest, animated: true, completion: { () -> Void in
            self.removeFromParentViewController()
        })
    }
    
    //停止番茄钟
    @IBAction func stop(sender: AnyObject) {
        //番茄数减一
        var tomatoNum = Conguration.getTomatoNum().tomatoNum
        let restNum = Conguration.getTomatoNum().restNum
        tomatoNum--
        Conguration.saveTomatoAndRestNum(tomatoNum, restNum: restNum)
    }
    
    /**
    /获取贝塞尔曲线1
    :returns: UIBezierPath
    */
    func getBezierPath1() -> UIBezierPath{
        
        var ovalPath = UIBezierPath(arcCenter: circularProgress.center, radius: circularProgress.frame.size.width / 2 - 5, startAngle: 0, endAngle: 2 * 3.14, clockwise: true)
        return ovalPath
    }
    
    /**
    /获取贝塞尔曲线2
    :returns: UIBezierPath
    */
    func getBezierPath2() -> UIBezierPath{
        
        var ovalPath = UIBezierPath(arcCenter: circularProgress.center, radius: self.view.frame.size.width / 2, startAngle: 0, endAngle: 2 * 3.14, clockwise: true)
        return ovalPath
    }
    
    /**
    /获取贝塞尔曲线3
    :returns: UIBezierPath
    */
    func getBezierPath3() -> UIBezierPath{
        
        var ovalPath = UIBezierPath(arcCenter: circularProgress.center, radius: circularProgress.frame.size.width / 2 - 15, startAngle: 0, endAngle: 2 * 3.14, clockwise: true)
        return ovalPath
    }
    
}
