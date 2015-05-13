//
//  RestViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/12/11.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit
import AVFoundation

class RestViewController: UIViewController {

    var taskTitle:String?
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var circularProgress: KYCircularProgress!
    
    @IBOutlet weak var trickView: UIView!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    
    @IBOutlet weak var tomatoStateLabel: UILabel!
    
    @IBOutlet weak var countButton: UIButton!
    
    @IBOutlet var indicatorImgViews: [UIImageView]!
   
    @IBOutlet weak var firstCenterX: NSLayoutConstraint!
    
    var tomatoTime:Double!
    var progress: Int = 0
    var timer:NSTimer!
    var minute:Int!
    var second:Int!
    var vibrateTimer:NSTimer!
    var player:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //指示动画

        let shortRest:AnyObject! = UIImage(named: "shortrest")
        let shortRest_gray:AnyObject! = UIImage(named: "shortrest_gray")
        let shortRests = [shortRest,shortRest_gray]
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
        
        
        if (Int(tomatoTime) % 60 < 10)
        {
            countButton.setTitle("\(Int(tomatoTime) / 60):0\(Int(tomatoTime) % 60)", forState: .Normal)
            
        }else
        {
            countButton.setTitle("\(Int(tomatoTime) / 60):\(Int(tomatoTime) % 60)", forState: .Normal)
        }
        
        // Do any additional setup after loading the view.
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
        if(player != nil)
        {
            player.stop()
            player = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
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
            countButton.setTitle("开始工作", forState: .Normal)
            countButton.titleLabel?.font = UIFont.systemFontOfSize(30.0)
            countButton.enabled = true
            //indicatorImgView.stopAnimating()
            
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
    
    
    //调用振动
    func vibrate() {
        vibrateTimer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: Selector("startVibrate"), userInfo: nil, repeats: true)
        
    }
    
    func startVibrate(){
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "checkSegue"){
            var check = segue.destinationViewController as! CheckViewController
           
            self.removeFromParentViewController()
        }
    }
    
    @IBAction func startTomato(sender: UIButton) {
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var tomatoViewController = storyBoard.instantiateViewControllerWithIdentifier("TomatoViewController") as! TomatoViewController
        let conguration = Conguration.getConguration()
        tomatoViewController.tomatoTime = Double(conguration.workTime * 60)
        var tomatoNum = Conguration.getTomatoNum().tomatoNum
        let restNum = Conguration.getTomatoNum().restNum
        tomatoNum++
        Conguration.saveTomatoAndRestNum(tomatoNum, restNum: restNum)
        tomatoViewController.taskTitle = self.taskTitleLabel.text
        self.presentViewController(tomatoViewController, animated: true, completion: { () -> Void in
            self.removeFromParentViewController()
        })
    }
    
    //停止番茄钟
    @IBAction func stop(sender: AnyObject) {
        //休息数减一
        let tomatoNum = Conguration.getTomatoNum().tomatoNum
        var restNum = Conguration.getTomatoNum().restNum
        restNum--
        Conguration.saveTomatoAndRestNum(tomatoNum, restNum: restNum)
    }
    

}
