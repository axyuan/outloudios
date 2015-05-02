//
//  ViewController.swift
//  outloud
//
//  Created by Ann Yuan on 4/3/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

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
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer = AVAudioPlayer()
    var recordedAudio: RecordedAudio!
    var recording: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVisibilityForRecordingState(currentRecordingState)
        
        remainingTime = timeLimit
        countdown.text = String(remainingTime)
        
        recording = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("applause", ofType: "mp3")!)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: recording, error: &error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func previewAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func countdownDisplay()
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
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdownDisplay"), userInfo: nil, repeats: true)
            setVisibilityForRecordingState(.InProgress)
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } else {
            timer.invalidate()
            remainingTime = timeLimit
            countdown.text = String(timeLimit)
            setVisibilityForRecordingState(.Completed)
            
            audioRecorder.stop()
            var audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(false, error: nil)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            var error:NSError?
            recording = recorder.url
            audioPlayer = AVAudioPlayer(contentsOfURL: recording, error: &error)
        }
        
    }
    
    @IBAction func deleteAudio(sender: UIButton) {
        audioPlayer.stop()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "publish" {
            let PublishVC:PublishViewController = segue.destinationViewController as! PublishViewController
            PublishVC.receivedAudio = recordedAudio
        }
    }
    
}

