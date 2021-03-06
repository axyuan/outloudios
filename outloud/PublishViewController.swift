//
//  PublishViewController.swift
//  outloud
//
//  Created by Ann Yuan on 4/29/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit
import AVFoundation

class PublishViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var textarea: UITextView!
    
    var receivedAudio:RecordedAudio!
    var caption = ""
    
    let manager = AFHTTPRequestOperationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textarea.layer.masksToBounds = true
        textarea.layer.borderColor = UIColor.grayColor().CGColor
        textarea.layer.borderWidth = 1.0
        textarea.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = count(textView.text) + count(text) - range.length
        return newLength <= 60
    }
    
    func textViewDidChange(textView: UITextView) {
        caption = textView.text
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if count(caption) == 0 {
            let alert = UIAlertView()
            alert.title = "No Text"
            alert.message = "Please assign a title to your recording"
            alert.addButtonWithTitle("OK")
            alert.show()
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var MainVC = segue.destinationViewController as! ViewController
        
        var newEntry = [String: AnyObject]()
        
        if let audio = receivedAudio?.filePathURL {
            newEntry["url"] = audio
        }
        
        newEntry["name"] = caption
        MainVC.tempSavedFile = newEntry
    }
}
