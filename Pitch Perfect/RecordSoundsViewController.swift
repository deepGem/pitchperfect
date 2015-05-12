//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by pbanavara on 11/05/15.
//  Copyright (c) 2015 pbanavara. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var labelCon: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    
    override func viewDidLoad() {
        labelCon.hidden = true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAction(sender: UIButton) {
        //TODO 
        labelCon.hidden = false
        stopButton.hidden = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingFileName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingFileName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error:nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        audioRecorder.delegate = self
        
        
    }

    @IBAction func stopRecord(sender: UIButton) {
        labelCon.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error:nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //TODO save the recorded audio
        if flag {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecordingSegue",sender: recordedAudio)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVc:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVc.receiveAudio = data
            
            
        }
    }
}

