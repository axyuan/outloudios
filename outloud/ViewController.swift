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
    var timeLimit: Int = 10
    
    var remainingTime: Int = 0
    
    enum RecordingState {
        case InProgress
        case Completed
        case Waiting
    }
    
    var timer = NSTimer()
    
    var currentRecordingState = RecordingState.Waiting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVisibilityForRecordingState(currentRecordingState)
        
        remainingTime = timeLimit
        countdown.text = String(remainingTime)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sayHello()
    {
        remainingTime = remainingTime - 1
        countdown.text = String(remainingTime)
        if remainingTime == 0 {
            toggleRecord(false)
        }
    }

    @IBAction func recordAudio(sender: UIButton) {
        if self.currentRecordingState == RecordingState.InProgress {
            toggleRecord(false)
        } else if self.currentRecordingState == RecordingState.Waiting {
            toggleRecord(true)
        }
    }
    
    func toggleRecord(record: Bool) {
        if record == true {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("sayHello"), userInfo: nil, repeats: true)
            setVisibilityForRecordingState(.InProgress)
        } else {
            timer.invalidate()
            remainingTime = timeLimit
            countdown.text = String(timeLimit)
            setVisibilityForRecordingState(.Completed)
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
            publishButton.hidden = true
        case .Completed:
            audioFile = true
            recordButton.hidden = true
            previewButton.hidden = false
            deleteButton.hidden = false
            countdown.hidden = true
            publishButton.hidden = false
        case .Waiting:
            recordButton.setTitle("Record", forState: .Normal)
            recordButton.hidden = false
            previewButton.hidden = true
            deleteButton.hidden = true
            countdown.hidden = true
            publishButton.hidden = true
        }
        
        currentRecordingState = state
        
    }
    
}

