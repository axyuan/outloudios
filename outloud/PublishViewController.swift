//
//  PublishViewController.swift
//  outloud
//
//  Created by Ann Yuan on 4/29/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController {
    
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var textarea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textarea.layer.masksToBounds = true
        textarea.layer.borderColor = UIColor.grayColor().CGColor
        textarea.layer.borderWidth = 1.0

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

}
