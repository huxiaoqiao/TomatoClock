//
//  AboutViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 15/3/23.
//  Copyright (c) 2015年 胡晓桥. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.view.subviews[1])
        print(self.view.subviews[3])
        
//        for obj:AnyObject in self.view.subviews {
//            print(obj)
//        }
//
//        let imageView = self.view.subviews[1] as! UIImageView
//        imageView.image = UIImage(named: "ShareImage")
//        
//        let label = self.view.subviews[3] as! UILabel
//        label.text = "番茄时钟 V1.1.0"
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
