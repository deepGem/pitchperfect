//
//  PalySoundsViewController.swift
//  Pitch Perfect
//
//  Created by pbanavara on 11/05/15.
//  Copyright (c) 2015 pbanavara. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    var receiveAudio: RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile: AVAudioFile!
    var pitchPlayer : AVAudioPlayerNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        var error:NSError?
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receiveAudio.filePathUrl, error: nil)
        
        if let error = error {
            println("Error in audio")
        } else {
            audioPlayer = AVAudioPlayer(contentsOfURL: receiveAudio.filePathUrl, error: &error)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSlowSound(sender: UIButton) {
        audioPlayer.stop()
        
        audioPlayer.enableRate = true
        audioPlayer.rate = 0.5
        audioPlayer.play()
            
    }
    
    @IBAction func playVaderSound(sender: UIButton) {
        playSoundWithPitch(-1000)
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        playSoundWithPitch(1000)
    }
    
    func playSoundWithPitch(pitch:Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        pitchPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(pitchPlayer)
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        pitchPlayer.play()
    }
    

    @IBAction func stopPlayingSound(sender: UIButton) {
        audioPlayer.stop()
        pitchPlayer.stop()
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        audioPlayer.enableRate = true
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
}
