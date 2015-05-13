//
//  RingSelectView.swift
//  TomatoClock
//
//  Created by 胡晓桥 on 15/1/29.
//  Copyright (c) 2015年 胡晓桥. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class RingSelectView: UIView,UITableViewDataSource,UITableViewDelegate {

    
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var names:NSDictionary!
    var keys:NSArray!
    var selectedRow:Int!
    var ringTypeArr:[AnyObject]!
    var soundIDs:[AnyObject]!
    var player:AVAudioPlayer!
    
    override func awakeFromNib() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 0.5
        
         ringTypeArr = ["Alarm","Apex","Ascending","Bark","Beacon","BellTower","Blues","Boing","Bulletin","ByTheSeaside","Chimes","Circuit","Constellation","Cosmic","Crickets","Crystals","Digital"];
        
        selectedRow = Conguration.getRingSelectRow().row
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ringTypeArr.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            
        }
        
        var nameStr:String = ringTypeArr[indexPath.row] as! String
        
        cell?.textLabel!.text = nameStr
        
        if(indexPath.row == selectedRow)
        {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else
        {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        var cell1:UITableViewCell? = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedRow, inSection: 0))
        
            cell1?.accessoryType = UITableViewCellAccessoryType.None
    
        var cell2:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell2.accessoryType = UITableViewCellAccessoryType.Checkmark

        if(player != nil)
        {
            player.stop()
            player = nil
        }
       
        var ringName:String = ringTypeArr[indexPath.row] as! String
        let urlStr = NSBundle.mainBundle().pathForResource(ringName, ofType: "m4r")
        let url = NSURL.fileURLWithPath(urlStr!)
        var error:NSError?
        player = AVAudioPlayer(contentsOfURL: url, error: &error)
        player.play()
        selectedRow = indexPath.row
    }
 
    //确定
    @IBAction func doneClick(sender: AnyObject) {
        var cell:UITableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedRow, inSection: 0))!
        let nameStr = ringTypeArr[selectedRow] as! String
        NSNotificationCenter.defaultCenter().postNotificationName("selectRingType", object: nameStr)
        Conguration.setRingTypeAndSelectRow(selectedRow, ringType: nameStr)
        close()
    }
    
    //取消
    @IBAction func cancelClick(sender: AnyObject) {
        close()
    }
    //关闭
    func close(){
        
        if(player != nil)
        {
            player.stop()
            player = nil
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.alpha = 0
            }) { (finished:Bool) -> Void in
            self.removeFromSuperview()
        }
        
    }
    
}
