//
//  AudioPlayer.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioPlayerProtocol: AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool)
}

class AudioPlayer: NSObject
{
    typealias function = () -> ()

    var audioPlayer = AVAudioPlayer()
    var timer: NSTimer!

    // Playlist
    var currentAudio = "";
    var currentAudioIndex = 0
    var currentAudioPath: NSURL?
    var audioLength = 0.0
    var audioList: [NSURL] = []

    // Events
    var playerDidStart: function?
    var playerDidStop: function?

    override init() {
        // Inherited
        super.init()
        // Audio Player
        //audioPlayer.delegate = self
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
        if let event = playerDidStart {
            event()
        }
        audioPlayer.play()
        //startTimer()
        saveCurrentTrackNumber()
    }

    func stopAudio() {
        if let event = playerDidStop {
            event()
        }
        audioPlayer.stop();
        if let current = currentAudioPath {
            prepareAudio(current)
        }
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

// MARK: AudioPlayerProtocol

extension AudioPlayer: AudioPlayerProtocol
{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {

    }
}
