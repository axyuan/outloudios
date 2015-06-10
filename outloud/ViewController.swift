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
    let timeLimit: Int = 10
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
    var savedFiles: [Dictionary<String, AnyObject>] = []
    var tempSavedFile = [String: AnyObject]()
    var loop:GameLoop!
    var circleView:CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        addCircleView()
        reset()
    }
    
    func addCircleView() {
        var circleWidth = CGFloat(200)
        var circleHeight = circleWidth
        circleView = CircleView(frame: CGRectMake((self.view.frame.width / 2) - (circleWidth / 2), (self.view.frame.height / 2) - (circleWidth / 2), circleWidth, circleHeight))
        
        view.addSubview(circleView)
        self.view.sendSubviewToBack(circleView)
    }
    
    func reset() {
        setVisibilityForRecordingState(.Waiting)
        remainingTime = timeLimit
        countdown.text = String(remainingTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "publish" {
            let PublishVC:PublishViewController = segue.destinationViewController as! PublishViewController
            PublishVC.receivedAudio = recordedAudio
        } else if segue.identifier == "listen" {
            let ListenVC:ListenViewController = segue.destinationViewController as! ListenViewController
            ListenVC.savedFiles = savedFiles
            ListenVC.modalParent = self
        }
    }
    
    @IBAction func previewAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        if self.currentRecordingState == RecordingState.InProgress {
            toggleRecord(false)
        } else if self.currentRecordingState == RecordingState.Waiting {
            toggleRecord(true)
        }
    }
    
    @IBAction func deleteAudio(sender: UIButton) {
        audioPlayer.stop()
        setVisibilityForRecordingState(.Waiting)
    }
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue)
    {
        let sourceViewController = sender.sourceViewController
        // Pull any data from the view controller which initiated the unwind segue.
        
        if let _ = tempSavedFile["url"] {
            savedFiles.append(tempSavedFile)
            tempSavedFile = [:]
        }
        
        reset()
    }
    
    func countdownDisplay() {
        remainingTime = remainingTime - 1
        countdown.text = String(remainingTime)
        audioRecorder.updateMeters()
        
//        var circleWidth = CGFloat(100)
//        var circleHeight = circleWidth
//        circleView.frame = CGRectMake((self.view.frame.width / 2) - (circleWidth / 2), (self.view.frame.height / 2) - (circleWidth / 2), circleWidth, circleHeight)
//        circleView.setNeedsDisplay()
        
        if remainingTime == 0 {
            toggleRecord(false)
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

            loop = GameLoop(frameInterval: 10, view: self)
            loop.start()
        } else {
            loop.stop()
            recordedAudio = RecordedAudio()
            recordedAudio.duration = timeLimit - remainingTime
            
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
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            var error:NSError?
            recording = recorder.url
            audioPlayer = AVAudioPlayer(contentsOfURL: recording, error: &error)
        }
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

