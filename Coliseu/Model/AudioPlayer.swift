//
//  AudioPlayer.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import AVFoundation

protocol AudioPlayerProtocol: AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool)
}

class AudioPlayer: NSObject
{
    typealias function = () -> ()

    var audioPlayer: AVAudioPlayer?
    var timer: NSTimer!

    // Playlist
    private var currentAudio = "";
    private var currentAudioIndex = 0
    private var currentAudioPath: NSURL?
    private var audioLength = 0.0
    var songsList: [AudioFile]?

    // Events
    var playerDidStart: function?
    var playerDidStop: function?

    override init()
    {
        // Inherited
        super.init()

    }

    func startSession()
    {
        // Session
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }

    private func prepareAudio(index: Int)
    {
        if let songs = songsList {
            if index >= 0 && index < songs.count {
                if let url = songs[index].path {
                    prepareAudio(url)
                }
            }
        }
    }

    private func prepareAudio(file: NSURL)
    {
        // Keep alive audio at background
        currentAudioPath = file;

        audioPlayer = AVAudioPlayer(contentsOfURL: currentAudioPath, error: nil)
        audioPlayer!.delegate = self
        audioPlayer!.prepareToPlay()
        audioLength = audioPlayer!.duration
    }

// MARK: Commands

    func playAudio()
    {
        if songsList == nil || songsList!.count == 0 {
            return
        }

        if let event = playerDidStart {
            event()
        }
        audioPlayer!.play()
        //startTimer()
        saveCurrentTrackNumber()
    }

    func playAudio(index: Int, songsList: [AudioFile])
    {
        self.songsList = songsList
        prepareAudio(index)
        playAudio()
    }

    func pauseAudio()
    {
        if audioPlayer!.playing {
            audioPlayer!.pause()
        }
    }

    func stopAudio()
    {
        if !audioPlayer!.playing {
            return
        }

        // ?
        self.songsList = nil;

        audioPlayer!.stop();
        if let event = playerDidStop {
            event()
        }
        if let current = currentAudioPath {
            prepareAudio(current)
        }
    }

    func playNextAudio()
    {
        if let songs = songsList {
            currentAudioIndex++
            if currentAudioIndex > songs.count - 1{
                currentAudioIndex--
                return
            }

            if audioPlayer!.playing {
                //prepareAudio()
                playAudio()
            } else {
                //prepareAudio()
            }
        }
    }

    func playPreviousAudio()
    {
        if let songs = songsList {
            currentAudioIndex--
            if currentAudioIndex < 0{
                currentAudioIndex++
                return
            }

            if audioPlayer!.playing {
                //prepareAudio()
                playAudio()
            } else {
                //prepareAudio()
            }
        }
    }

// MARK: Config

    func saveCurrentTrackNumber()
    {
        NSUserDefaults.standardUserDefaults().setObject(currentAudioIndex, forKey:"currentAudioIndex")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func retrieveSavedTrackNumber()
    {
        if let index = NSUserDefaults.standardUserDefaults().objectForKey("currentAudioIndex") as? Int {
            currentAudioIndex = index
        }else{
            currentAudioIndex = 0
        }
    }
}

// MARK: AudioPlayerProtocol

extension AudioPlayer: AudioPlayerProtocol
{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool)
    {
        // ToDo: Next song

    }
}
