//
//  TimeSettingView.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/12/4.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit

class TimeSettingView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var timeSetModalVC:TimeSetModalViewController?
    
    @IBOutlet weak var workTimeLabel: UILabel!

    @IBOutlet weak var workTimeSwitch: UISlider!
    
    @IBOutlet weak var shortrestTimeLabel: UILabel!
    
    @IBOutlet weak var shortrestTimeSwitch: UISlider!
    
    @IBOutlet weak var longrestTimeLabel: UILabel!
    
    @IBOutlet weak var longrestTimeSwitch: UISlider!
    
    override func awakeFromNib() {
        
        self.clipsToBounds = true
        //self.layer.cornerRadius = 3
        
        self.workTimeSwitch.setThumbImage(UIImage(named: "button_slider"), forState: UIControlState.Normal)
        self.shortrestTimeSwitch.setThumbImage(UIImage(named: "button_slider"), forState: UIControlState.Normal)
        self.longrestTimeSwitch.setThumbImage(UIImage(named: "button_slider"), forState: UIControlState.Normal)
        
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("workTime") == nil)
        {
            workTimeSwitch.value = 25
            shortrestTimeSwitch.value = 5
            longrestTimeSwitch.value = 20
            workTimeLabel.text = "25"
            shortrestTimeLabel.text = "5"
            longrestTimeLabel.text = "20"
        }else
        {
            let conguration = getConguration()
            workTimeSwitch.value = Float(conguration.workTime)
            shortrestTimeSwitch.value = Float(conguration.shortrestTime)
            longrestTimeSwitch.value = Float(conguration.longrestTime)
            workTimeLabel.text = "\(conguration.workTime)"
            shortrestTimeLabel.text = "\(conguration.shortrestTime)"
            longrestTimeLabel.text = "\(conguration.longrestTime)"
        }
        
        
    }
    
    @IBAction func workTimeDidChaged(sender: UISlider) {
        workTimeLabel.text = "\(Int(sender.value))"
        if(sender.value == 0)
        {
            workTimeSwitch.setValue(1.0, animated: true)
            workTimeLabel.text = "1";
        }
    }
    
    @IBAction func shortrestTimeDidChanged(sender: UISlider) {
        shortrestTimeLabel.text = "\(Int(sender.value))"
        if(sender.value == 0)
        {
            shortrestTimeSwitch.setValue(1.0, animated: true)
            shortrestTimeLabel.text = "1";
        }

    }
    
    @IBAction func longrestTimeDidChanged(sender: UISlider) {
        longrestTimeLabel.text = "\(Int(sender.value))"
        if(sender.value == 0)
        {
            longrestTimeSwitch.setValue(1.0, animated: true)
            longrestTimeLabel.text = "1";
        }

    }
    
    
    @IBAction func cancel(sender: UIButton) {
        close()
    }
    
    @IBAction func done(sender: UIButton) {
        saveConguration(Int(workTimeSwitch.value), shortrestTime: Int(shortrestTimeSwitch.value), longrestTime: Int(longrestTimeSwitch.value))
        postNotification()
        close()
    }
    
    func close(){
        
 
    
        self.timeSetModalVC!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}

