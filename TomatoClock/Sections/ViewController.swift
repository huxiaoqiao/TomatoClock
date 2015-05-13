//
//  ViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/11/28.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var editTextImgView: UIImageView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var tomatoButton: UIButton!
    @IBOutlet weak var shortrestButton: UIButton!
    @IBOutlet weak var longrestButton: UIButton!
    @IBOutlet weak var inputOkButton: UIButton!
    @IBOutlet weak var tomatoLabel: UILabel!
    @IBOutlet weak var shortrestLabel: UILabel!
    @IBOutlet weak var longrestLabel: UILabel!
    
    var timeSettingView:TimeSettingView!
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginButton.layer.cornerRadius = 30 * SCREEN_WIDTH / 320.0;
        beginButton.layer.borderWidth = 0.5
        beginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        inputOkButton.hidden = true
        
        var image = UIImage(named: "bg_edittext_off")
        var editTextOffImg = image?.stretchableImageWithLeftCapWidth(3, topCapHeight: 2)
        editTextImgView.image = editTextOffImg;
        
        let conguration = Conguration.getConguration()
        if (NSUserDefaults.standardUserDefaults().valueForKey("workTime") != nil)
        {
            tomatoLabel.text = "\(conguration.workTime)分钟"
            shortrestLabel.text = "\(conguration.shortrestTime)分钟"
            longrestLabel.text = "\(conguration.longrestTime)分钟"
        }
        NSNotificationCenter.defaultCenter().addObserverForName("congurationChanged", object: nil, queue: nil) { (note:NSNotification!) -> Void in
            let conguration = Conguration.getConguration()
            self.tomatoLabel.text = "\(conguration.workTime)分钟"
            self.shortrestLabel.text = "\(conguration.shortrestTime)分钟"
            self.longrestLabel.text = "\(conguration.longrestTime)分钟"
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        inputOkButton.hidden = false
        var image = UIImage(named: "bg_edittext_on")
        var editTextOnImg = image?.stretchableImageWithLeftCapWidth(3, topCapHeight: 2)
        editTextImgView.image = editTextOnImg
    }
    
    @IBAction func inputOk(sender: UIButton) {
        inputOkButton.hidden = true
        var image = UIImage(named: "bg_edittext_off")
        var editTextOffImg = image?.stretchableImageWithLeftCapWidth(3, topCapHeight: 2)
        editTextImgView.image = editTextOffImg;
        
        taskTextField.resignFirstResponder()
        
    }

    
    //Actions
    @IBAction func tomatoDidClick(sender: UIButton) {
        self.showSettingView()
    }
  
  
    @IBAction func shortrestDidClick(sender: UIButton) {
        self.showSettingView()
    }
    
    @IBAction func longrestDidClick(sender: UIButton) {
        self.showSettingView()
    }
    

    @IBAction func beginTomato(sender: UIButton) {
    }
    
    func showSettingView(){
        
        timeSettingView = NSBundle.mainBundle().loadNibNamed("TimeSettingView", owner: self, options: nil)[0] as! TimeSettingView
        timeSettingView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)
        
       self.view.addSubview(timeSettingView)
        
        timeSettingView.alpha = 0
        timeSettingView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.timeSettingView.alpha = 1
            self.timeSettingView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "tomato")
        {
            
         var tomato:TomatoViewController! = segue.destinationViewController as! TomatoViewController
            let conguration = Conguration.getConguration()
           tomato.tomatoTime = Double(conguration.workTime * 60)
            Conguration.saveTomatoAndRestNum(1, restNum: 0)
            
            if (taskTextField.text == "")
            {
               Conguration.saveTaskTitle("未命名任务")
            }else{
               Conguration.saveTaskTitle(taskTextField.text)
            }
        }
    }
    
}
