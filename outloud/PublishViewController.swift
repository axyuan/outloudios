//
//  PublishViewController.swift
//  outloud
//
//  Created by Ann Yuan on 4/29/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit

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

    @IBAction func publish(sender: CustomButton) {
        var getPresignedPostParameters = [
            "title": caption,
            "duration": receivedAudio.duration,
            "tags": []
        ]
        
        manager.GET( "https://out-loud-heroku-test.herokuapp.com/api/presigned_post",
            parameters: getPresignedPostParameters,
            success: post,
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    func post(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) {
        var parameters = [String: AnyObject]()
        
        if let id = responseObject?.objectForKey("AWSAccessKeyId") as? String {
            parameters["AWSAccessKeyId"] = id
        }
        
        if let key = responseObject?.objectForKey("key") as? String {
            parameters["key"] = key
        }
        
        if let policy = responseObject?.objectForKey("policy") as? String {
            parameters["policy"] = policy
        }
        
        if let signature = responseObject?.objectForKey("signature") as? String {
            parameters["signature"] = signature
        }
        
        parameters["file"] = receivedAudio
        
        println(parameters)
        
        manager.POST( "https://s3.amazonaws.com/out-loud",
        parameters: parameters,
        success: postSuccess,
        failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
            println(error.localizedDescription)
        })
    }
    
    func postSuccess(operation: AFHTTPRequestOperation!,responseObject: AnyObject!) {
        println("AWS SUCCESS - READY TO POST")
        println(responseObject.description)
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
