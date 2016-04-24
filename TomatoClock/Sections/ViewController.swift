//
//  ViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/11/28.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit


class ViewController: UIViewController , UITextFieldDelegate,UIViewControllerTransitioningDelegate{

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginButton.layer.cornerRadius = 30 * SCREEN_WIDTH / 320.0;
        beginButton.layer.borderWidth = 0.5
        beginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        inputOkButton.hidden = true
        
        let image = UIImage(named: "bg_edittext_off")
        let editTextOffImg = image?.stretchableImageWithLeftCapWidth(3, topCapHeight: 2)
        editTextImgView.image = editTextOffImg;
        
        let times = getTimeSetting()
        if (NSUserDefaults.standardUserDefaults().valueForKey("workTime") != nil)
        {
            tomatoLabel.text = "\(times.workTime)分钟"
            shortrestLabel.text = "\(times.shortrestTime)分钟"
            longrestLabel.text = "\(times.longrestTime)分钟"
        }
        NSNotificationCenter.defaultCenter().addObserverForName("congurationChanged", object: nil, queue: nil) { (note:NSNotification!) -> Void in
            let times = getTimeSetting()
            self.tomatoLabel.text = "\(times.workTime)分钟"
            self.shortrestLabel.text = "\(times.shortrestTime)分钟"
            self.longrestLabel.text = "\(times.longrestTime)分钟"
        }
          self.view.backgroundColor = UIColor.init(colorLiteralRed: 27 / 255.0, green: 161 / 255.0, blue: 226 / 255.0, alpha: 1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        inputOkButton.hidden = false
        let image = UIImage(named: "bg_edittext_on")
        let editTextOnImg = image?.stretchableImageWithLeftCapWidth(3, topCapHeight: 2)
        editTextImgView.image = editTextOnImg
    }
    
    @IBAction func inputOk(sender: UIButton) {
        inputOkButton.hidden = true
        let image = UIImage(named: "bg_edittext_off")
        let editTextOffImg = image?.stretchableImageWithLeftCapWidth(3, topCapHeight: 2)
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
        
        let timeSetModalVC:TimeSetModalViewController = TimeSetModalViewController()
        timeSetModalVC.transitioningDelegate = self
        timeSetModalVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        self .presentViewController(timeSetModalVC, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "tomato")
        {
            
         let tomato:TomatoViewController! = segue.destinationViewController as! TomatoViewController
            let times = getTimeSetting()
           tomato.tomatoTime = Double(times.workTime * 60)
            saveTomatoAndRestNum(1, restNum: 0)
            
            if (taskTextField.text == "")
            {
               saveTaskTitle("未命名任务")
            }else{
               saveTaskTitle(taskTextField.text!)
            }
        }
    }
    
     //MARK: - UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowShareSDK().presentingAnimator() as? UIViewControllerAnimatedTransitioning
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowShareSDK().dismissingAnimator() as? UIViewControllerAnimatedTransitioning
    }
    
}
