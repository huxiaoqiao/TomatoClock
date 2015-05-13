//
//  SettingViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/11/30.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit
import AudioToolbox

class SettingViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var shortRestTimeLabel: UILabel!
    @IBOutlet weak var longRestTimeLabel: UILabel!
    
    @IBOutlet weak var workTimeSlider: UISlider!
    @IBOutlet weak var shortRestTImeSlider: UISlider!
    @IBOutlet weak var longRestTimeSlider: UISlider!
    
    @IBOutlet weak var ringSwitch: UISwitch!
    @IBOutlet weak var ringTypeLabel: UILabel!
    @IBOutlet weak var ringTypeButton: UIButton!
    
    @IBOutlet weak var vibrateSwitch: UISwitch!
    
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("workTime") == nil)
        {
            workTimeSlider.value = 25
            shortRestTImeSlider.value = 5
            longRestTimeSlider.value = 20
            workTimeLabel.text = "25"
            shortRestTimeLabel.text = "5"
            longRestTimeLabel.text = "20"
        }else
        {
            let conguration = Conguration.getConguration()
            workTimeSlider.value = Float(conguration.workTime)
            shortRestTImeSlider.value = Float(conguration.shortrestTime)
            longRestTimeSlider.value = Float(conguration.longrestTime)
            workTimeLabel.text = "\(conguration.workTime)"
            shortRestTimeLabel.text = "\(conguration.shortrestTime)"
            longRestTimeLabel.text = "\(conguration.longrestTime)"
        }
        
        vibrateSwitch.setOn(Conguration.getVibrateSwitch(), animated: false)
        ringTypeLabel.text = Conguration.getRingSelectRow().ringType
        
        NSNotificationCenter.defaultCenter().addObserverForName("selectRingType", object: nil, queue: nil) { (note:NSNotification!) -> Void in
            let ringType:String = note.object as! String
            self.ringTypeLabel.text = ringType
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        Conguration.saveConguration(Int(workTimeSlider.value), shortrestTime: Int(shortRestTImeSlider.value), longrestTime: Int(longRestTimeSlider.value))
        Conguration.postNotification()
    }
    
    @IBAction func workTimeChanged(sender: UISlider) {
        
        workTimeLabel.text = "\(Int(sender.value))"
        if(sender.value == 0)
        {
            workTimeSlider.setValue(1.0, animated: true)
            workTimeLabel.text = "1";
        }

    }
    
    @IBAction func shortRestTimeChanged(sender: UISlider) {
        shortRestTimeLabel.text = "\(Int(sender.value))"
        if(sender.value == 0)
        {
            shortRestTImeSlider.setValue(1.0, animated: true)
            shortRestTimeLabel.text = "1";
        }
    }
    
    
    @IBAction func longRestTimeChanged(sender: UISlider) {
        longRestTimeLabel.text = "\(Int(sender.value))"
        if(sender.value == 0)
        {
            longRestTimeSlider.setValue(1.0, animated: true)
            longRestTimeLabel.text = "1";
        }
    }

    
    //选择铃声
    @IBAction func selectRingType(sender: AnyObject) {
        var ringSelectView:RingSelectView = NSBundle.mainBundle().loadNibNamed("RingSelectView", owner: self, options: nil)[0] as! RingSelectView
        ringSelectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        self.view.addSubview(ringSelectView)
        
        ringSelectView.alpha = 0
        ringSelectView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            ringSelectView.alpha = 1
            ringSelectView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
        
    }
    
    //响铃开关
    @IBAction func ringSwitchChanged(sender:UISwitch){
        if(sender.on == true){
            Conguration.setRingSwitch(true)
        }else{
            Conguration.setRingSwitch(false)
        }
    }
     //振动开关
    @IBAction func vibrateSwitchChanged(sender: UISwitch) {
        if(sender.on == true)
        {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            Conguration.setVibrateSwitch(true)
        }else
        {
            Conguration.setVibrateSwitch(false)
        }
    }
    
    //关于
    @IBAction func toAbout(sender: AnyObject) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
