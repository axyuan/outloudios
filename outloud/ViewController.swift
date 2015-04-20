//
//  ViewController.swift
//  outloud
//
//  Created by Ann Yuan on 4/3/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var publishButton: UIButton!
    
    var recording: Bool = false
    var audioFile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRecordButtonText()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recording = !recording
        
        if(recording == false) {
            audioFile = true
            recordButton.hidden = true
            previewButton.hidden = false
            deleteButton.hidden = false
        }
        
        setRecordButtonText()
    }
    
    @IBAction func deleteAudio(sender: UIButton) {
        audioFile = false
        recordButton.hidden = false
        previewButton.hidden = true
        deleteButton.hidden = true
    }
    
    func setRecordButtonText() {
        if(recording == true) {
            recordButton.setTitle("Stop", forState: .Normal)
        } else {
            recordButton.setTitle("Record", forState: .Normal)
        }
    }

}

