//
//  CheckViewController.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 14/12/2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var markImgView: UIImageView!
    var didClicked:Bool!
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width
   
    
    var isChecked:Bool = false
    var checkUndoneTitles:[String]!
    var checkDoneTitles:[String]!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet var indicatorImgViews: [UIImageView]!
    
    @IBOutlet weak var leftCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var rightCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var leftQuotesImgView: UIImageView!
    @IBOutlet weak var rightQuotesImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = SCREEN_WIDTH / 320.0 * 75
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 5
        didClicked = false
        
        leftButton.layer.cornerRadius = 30 * SCREEN_WIDTH / 320.0
        leftButton.layer.borderColor = UIColor.whiteColor().CGColor
        leftButton.layer.borderWidth = 0.5
        
        rightButton.layer.cornerRadius = 30 * SCREEN_WIDTH / 320.0
        rightButton.layer.borderColor = UIColor.whiteColor().CGColor
        rightButton.layer.borderWidth = 0.5
        taskTitleLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("TaskTitle") as? String

        let tomato_break = UIImage(named: "tomato_break");
        
        checkUndoneTitles = ["都已经开始了,离完成还远吗？","坚持一下，胜利就在前方！"]
        checkDoneTitles = ["我是超人，手指一戳，任务完成！","好开心，经过\(Conguration.getTomatoNum().tomatoNum)个番茄的奋战和\(Conguration.getTomatoNum().restNum)次休息，终于完成！"]
        
       
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneButtonDidClick(sender: AnyObject) {
        if !didClicked
        {
            doneButton.backgroundColor = UIColor.greenColor()
            markImgView.image = UIImage(named: "icon_status_finished")
            didClicked = !didClicked
            startCheckAnimation()
            
        }else
        {
            doneButton.backgroundColor = UIColor.clearColor()
            markImgView.image = UIImage(named: "icon_status_unfinished")
            didClicked = !didClicked
            startUncheckAnimation()
        }
    }
    
    func startCheckAnimation(){
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            //标题
            self.remarkLabel.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.remarkLabel.alpha = 0.1
            self.leftQuotesImgView.transform = CGAffineTransformMakeTranslation(-40, 0);
            self.rightQuotesImgView.transform = CGAffineTransformMakeTranslation(40, 0);
            
            //按钮
            self.leftButton.transform = CGAffineTransformMakeTranslation(-80, 0)
            self.rightButton.transform = CGAffineTransformMakeTranslation(80, 0)
            self.leftButton.alpha = 0.1
            self.rightButton.alpha = 0.1
            
            }) { (finished:Bool) -> Void in
                //标题
                let tomatoNum:Int = Conguration.getTomatoNum().tomatoNum
                let restNum:Int = Conguration.getTomatoNum().restNum
                if (tomatoNum >= 1 &&  restNum >= 1)
                {
                    self.remarkLabel.text = self.checkDoneTitles[1]
                }else
                {
                     self.remarkLabel.text = self.checkDoneTitles[0]
                }
                self.remarkLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.leftQuotesImgView.transform = CGAffineTransformMakeTranslation(80, 0)
                self.rightQuotesImgView.transform = CGAffineTransformMakeTranslation(-80, 0)
                
                //按钮
                self.leftButton.setTitle("分享成果", forState: UIControlState.Normal)
                self.rightButton.setTitle("开始新的", forState: UIControlState.Normal)
                
                self.isChecked = true
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    //标题
                    self.remarkLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    self.remarkLabel.alpha = 1
                    self.leftQuotesImgView.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.rightQuotesImgView.transform = CGAffineTransformMakeTranslation(0, 0)
                    
                    //按钮
                    self.leftButton.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.leftButton.alpha = 1
                    self.rightButton.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.rightButton.alpha = 1
                })
        }
        
    }
    
    func startUncheckAnimation(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            //标题
            self.remarkLabel.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.remarkLabel.alpha = 0.1
            self.leftQuotesImgView.transform = CGAffineTransformMakeTranslation(-40, 0);
            self.rightQuotesImgView.transform = CGAffineTransformMakeTranslation(40, 0);
            
            //按钮
            self.leftButton.transform = CGAffineTransformMakeTranslation(-80, 0)
            self.rightButton.transform = CGAffineTransformMakeTranslation(80, 0)
            self.leftButton.alpha = 0.1
            self.rightButton.alpha = 0.1
            
            }) { (finished:Bool) -> Void in
                //标题
                let tomatoNum:Int = Conguration.getTomatoNum().tomatoNum
                let restNum:Int = Conguration.getTomatoNum().restNum
                if (tomatoNum >= 1 &&  restNum >= 1)
                {
                    self.remarkLabel.text = self.checkUndoneTitles[1]
                }else
                {
                    self.remarkLabel.text = self.checkUndoneTitles[0]
                }

                self.remarkLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.leftQuotesImgView.transform = CGAffineTransformMakeTranslation(80, 0)
                self.rightQuotesImgView.transform = CGAffineTransformMakeTranslation(-80, 0)
                //按钮
                self.leftButton.setTitle("开始休息", forState: UIControlState.Normal)
                self.rightButton.setTitle("开始工作", forState: UIControlState.Normal)
                
                self.isChecked = false
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    //标题
                    self.remarkLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    self.remarkLabel.alpha = 1
                    self.leftQuotesImgView.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.rightQuotesImgView.transform = CGAffineTransformMakeTranslation(0, 0)
                    //按钮
                    self.leftButton.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.leftButton.alpha = 1
                    self.rightButton.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.rightButton.alpha = 1
                })
        }

    }
    
    //左边按钮事件
    @IBAction func leftButtonDidClick(sender: AnyObject) {
        if(self.isChecked == false){
            //开始休息
            let storyBoard = UIStoryboard(name: "Main", bundle: nil);
            let rest = storyBoard.instantiateViewControllerWithIdentifier("RestViewController") as! RestViewController
            let conguration = Conguration.getConguration()
            rest.tomatoTime = Double(conguration.shortrestTime * 60)
            rest.taskTitle = taskTitleLabel.text
            self.presentViewController(rest, animated: true, completion: { () -> Void in
                self.removeFromParentViewController()
                
                Conguration.saveTomatoAndRestNum(0, restNum: 1)
                
            })
        }else{
            //分享成果
            //弹出分享框
            ShareSDKTool.showShareActionSheet()
 
        }
    }
    //右边按钮事件
    @IBAction func rightButtonDidClick(sender: AnyObject) {
        if(self.isChecked == false){
            //开始工作
            let storyBoard = UIStoryboard(name: "Main", bundle: nil);
            let tomato = storyBoard.instantiateViewControllerWithIdentifier("TomatoViewController") as! TomatoViewController
            let conguration = Conguration.getConguration()
            tomato.tomatoTime = Double(conguration.workTime * 60)
            tomato.taskTitle = taskTitleLabel.text
            self.presentViewController(tomato, animated: true, completion: { () -> Void in
                self.removeFromParentViewController()
                Conguration.saveTomatoAndRestNum(1, restNum: 0)

            })
            
        }else{
            //开始新的
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyBoard.instantiateInitialViewController() as! ViewController
            main.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.presentViewController(main, animated: true, completion: { () -> Void in
                self.removeFromParentViewController()
            })
        }
    }
    
    
}
