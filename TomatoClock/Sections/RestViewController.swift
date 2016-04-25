//
//  RestViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/12/11.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit

class RestViewController: UIViewController {

    var taskTitle:String?
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var circularProgress: KYCircularProgress!
    
    @IBOutlet weak var trickView: UIView!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    
    @IBOutlet weak var tomatoStateLabel: UILabel!
    
    @IBOutlet weak var countButton: UIButton!
   
    @IBOutlet weak var firstCenterX: NSLayoutConstraint!
    
    var tomatoTime:Double!
    var progress: Int = 0
    var timer:NSTimer!
    let myTimer = Timer.sharedInstance
    var ripplesLayer:DWRipplesLayer = DWRipplesLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化UI
        self.initUIElements()
        myTimer.restFireTime = Int(self.tomatoTime)
        myTimer.timerWillState = timerState.rest
        myTimer.delegate = self
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        //开始计时
        myTimer.timerWillAction()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(true)
        if(timer != nil)
        {
            timer .invalidate()
            timer = nil
        }
        if myTimer.timer != nil {
            myTimer.timer.invalidate()
            myTimer.timer = nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initUIElements(){
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 175 / 255.0, blue: 108 / 255.0, alpha: 1.0)
        
        taskTitleLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("TaskTitle") as? String
        
        stopButton.layer.cornerRadius = 30 * SCREEN_WIDTH / 320.0
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
        
        let center:CGPoint = CGPointMake(SCREEN_WIDTH / 2.0, self.trickView.center.y)

        let backView:UIView = UIView()
        backView.bounds = CGRectMake(0, 0, 270, 270)
        backView.layer.cornerRadius = 135
        backView.center = center
        backView.backgroundColor = self.view.backgroundColor
        self.view.insertSubview(backView, belowSubview: trickView)
        
        //rippleLayer
        self.view.layer.insertSublayer(self.ripplesLayer, below: backView.layer)

        self.ripplesLayer.position = center
        self.ripplesLayer.radius = 280
        self.ripplesLayer.animationDuration = 4.0
        
        self.view.bringSubviewToFront(countButton)
        
        countButton.setTitle(formatToDisplayTime(Int(tomatoTime)), forState: .Normal)
        countButton.enabled = false
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(RestViewController.updateProgress), userInfo: nil, repeats: true)
        
        
    }
    //更新进度条
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "checkSegue"){
            //let check = segue.destinationViewController as! CheckViewController
           
            self.removeFromParentViewController()
        }
    }
    //开始工作
    @IBAction func startTomato(sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tomatoViewController = storyBoard.instantiateViewControllerWithIdentifier("TomatoViewController") as! TomatoViewController
        let times = getTimeSetting()
        tomatoViewController.tomatoTime = Double(times.workTime * 60)
        var tomatoNum = getTomatoNum().tomatoNum
        let restNum = getTomatoNum().restNum
        tomatoNum += 1
        saveTomatoAndRestNum(tomatoNum, restNum: restNum)
        tomatoViewController.taskTitle = self.taskTitleLabel.text
        self.presentViewController(tomatoViewController, animated: true, completion: { () -> Void in
            self.removeFromParentViewController()
        })
    }
    
    //停止番茄钟
    @IBAction func stop(sender: AnyObject) {
        //休息数减一
        
        let tomatoNum = getTomatoNum().tomatoNum
        var restNum = getTomatoNum().restNum
        restNum -= 1
        saveTomatoAndRestNum(tomatoNum, restNum: restNum)
    }

}

extension RestViewController:TimerDelegate{
    func timerStateToController(timerWillState: String) {
        switch timerWillState {
        case timerState.rest:
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
            countButton.setTitle("开始工作", forState: .Normal)
            countButton.titleLabel?.font = UIFont.systemFontOfSize(36)
            countButton.enabled = true
            circularProgress.progress = 0
            self.ripplesLayer.startAnimation()
        }else{
            print(currentTime)
            countButton.setTitle(formatToDisplayTime(currentTime), forState: .Normal)
            let normalizedProgress = Double(currentTime - 1) / tomatoTime
            circularProgress.progress = normalizedProgress
        }
        
        
    }
    
}



