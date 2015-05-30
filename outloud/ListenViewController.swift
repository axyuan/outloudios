//
//  ListenViewController.swift
//  outloud
//
//  Created by Ann Yuan on 5/23/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit
import AVFoundation

class ListenViewController: UIViewController {

    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var scroller: UIScrollView!
    
    var savedFiles: [Dictionary<String, AnyObject>] = []
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        renderFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderFiles() {
        for view in scroller.subviews {
            view.removeFromSuperview()
        }
        
        let buttonHeight = CGFloat(100)
        
        for var i=0; i<savedFiles.count; i++ {
            let buttonView = UIButton()
            buttonView.setTitle(savedFiles[i]["name"] as! String, forState: .Normal)
            buttonView.setTitleColor(UIColor.blueColor(), forState: .Normal)
            buttonView.frame = CGRectMake(10, 30 + 60 * CGFloat(i), 100, buttonHeight)
            buttonView.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
            scroller.addSubview(buttonView)
            
            let deleteButtonView = CustomDeleteButton()
            deleteButtonView.index = i;
            deleteButtonView.setTitle("delete", forState: .Normal)
            deleteButtonView.setTitleColor(UIColor.blueColor(), forState: .Normal)
            deleteButtonView.frame = CGRectMake(100, 30 + 60 * CGFloat(i), 100, buttonHeight)
            deleteButtonView.addTarget(self, action: "deleteAudio:", forControlEvents: .TouchUpInside)
            scroller.addSubview(deleteButtonView)
        }
        
        scroller.contentSize = CGSizeMake(320, CGFloat(savedFiles.count) * buttonHeight)
    }
    
    func pressed(sender: UIButton!) {
        var targetURL:NSURL
        
        for var i=0; i<savedFiles.count; i++ {
            if savedFiles[i]["name"] as! String == sender.titleLabel!.text {
                var error:NSError?
                audioPlayer = AVAudioPlayer(contentsOfURL: savedFiles[i]["url"] as! NSURL, error: &error)
                audioPlayer.play()
            }
        }
    }
    
    func deleteAudio(sender: UIButton!) {
        let button = sender as! CustomDeleteButton
        println(button.index)
        
        savedFiles.removeAtIndex(button.index)
        renderFiles()
    }
    
    @IBAction func done(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
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
