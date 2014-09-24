//
//  AudioPlayer.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {

    //audioPlayerDidFinishPlaying: Delegate AVAudioPlayerDelegate

    var audioPlayer = AVAudioPlayer()
    var currentAudio = "";
    var currentAudioPath: NSURL!
    var currentAudioIndex = 0
    var audioList: [NSURL] = []
    var timer: NSTimer!
    var audioLength = 0.0

    init() {

    }

    func prepareAudio(file: NSURL) {
        // Keep alive audio at background
        currentAudioPath = file;
        audioPlayer = AVAudioPlayer(contentsOfURL: currentAudioPath, error: nil)
        audioLength = audioPlayer.duration
        audioPlayer.prepareToPlay()

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }

    func saveCurrentTrackNumber() {
        NSUserDefaults.standardUserDefaults().setObject(currentAudioIndex, forKey:"currentAudioIndex")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func retrieveSavedTrackNumber() {
        if let index = NSUserDefaults.standardUserDefaults().objectForKey("currentAudioIndex") as? Int{
            currentAudioIndex = index
        }else{
            currentAudioIndex = 0
        }
    }

    func  playAudio() {
        audioPlayer.play()
        //startTimer()
        saveCurrentTrackNumber()
    }

    func stopAudio() {
        audioPlayer.stop();
    }

    func playNextAudio() {
        currentAudioIndex++
        if currentAudioIndex>audioList.count-1{
            currentAudioIndex--
            return
        }
        if audioPlayer.playing{
            //prepareAudio()
            playAudio()
        }else{
            //prepareAudio()
        }

    }

    func playPreviousAudio() {
        currentAudioIndex--
        if currentAudioIndex<0{
            currentAudioIndex++
            return
        }
        if audioPlayer.playing{
            //prepareAudio()
            playAudio()
        }else{
            //prepareAudio()
        }

    }

    func pauseAudio() {
        audioPlayer.pause()
    }

}