//
//  TimeSetModalViewController.swift
//  TomatoClock
//
//  Created by XiaoqiaoHu on 15/5/15.
//  Copyright (c) 2015年 胡晓桥. All rights reserved.
//

import UIKit

class TimeSetModalViewController: ModalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor .redColor()
        let timeSettingView = NSBundle.mainBundle().loadNibNamed("TimeSettingView", owner: self, options: nil)[0] as! TimeSettingView
            timeSettingView.timeSetModalVC = self
        
       // timeSettingView.center = self.view.center
        
        self.view.addSubview(timeSettingView)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - 确定
    @IBAction func doneClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 取消
    @IBAction func cancelClicked(sender: AnyObject){
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
