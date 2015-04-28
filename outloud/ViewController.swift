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
    
    @IBOutlet weak var countdown: UILabel!
    
    var audioFile: Bool = false
    var timeLimit: Int = 15
    
    enum RecordingState {
        case InProgress
        case Completed
        case Waiting
    }
    
    var currentRecordingState = RecordingState.Waiting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVisibilityForRecordingState(currentRecordingState)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        if self.currentRecordingState == RecordingState.InProgress {
            setVisibilityForRecordingState(.Completed)
        } else if self.currentRecordingState == RecordingState.Waiting {
            setVisibilityForRecordingState(.InProgress)
        }
    }
    
    @IBAction func deleteAudio(sender: UIButton) {
        setVisibilityForRecordingState(.Waiting)
    }
    
    func setVisibilityForRecordingState(state: RecordingState) {
        switch state {
        case .InProgress:
            recordButton.setTitle("Stop", forState: .Normal)
            recordButton.hidden = false
            previewButton.hidden = true
            deleteButton.hidden = true
            countdown.hidden = false
        case .Completed:
            audioFile = true
            recordButton.hidden = true
            previewButton.hidden = false
            deleteButton.hidden = false
            countdown.hidden = true
        case .Waiting:
            recordButton.setTitle("Record", forState: .Normal)
            recordButton.hidden = false
            previewButton.hidden = true
            deleteButton.hidden = true
            countdown.hidden = true
        }
        
        currentRecordingState = state
        
    }
    
}

