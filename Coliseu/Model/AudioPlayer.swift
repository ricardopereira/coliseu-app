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
    private var currentSong: AudioFile?
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
                prepareAudio(songs[index], index)
            }
        }
    }

    private func prepareAudio(song: AudioFile, _ index: Int)
    {
        // Keep alive audio at background
        if song.path == nil {
            currentSong = nil
            return
        }
        else {
            currentSong = song
            song.index = index
        }

        audioPlayer = AVAudioPlayer(contentsOfURL: song.path, error: nil)
        audioPlayer!.delegate = self
        audioPlayer!.prepareToPlay()
        // ?
        song.duration = audioPlayer!.duration
    }

    func songListIsValid() -> Bool
    {
        if songsList == nil || songsList!.count == 0 {
            return false
        }
        else {
            return true
        }
    }

// MARK: Commands

    func playSong()
    {
        // Verify if has a valid playlist to play
        if !songListIsValid() {
            return
        }
        // Check the didStart event
        if let event = playerDidStart {
            event()
        }
        audioPlayer!.play()
    }

    func playSong(index: Int, songsList: [AudioFile])
    {
        self.songsList = songsList
        // Prepare core audio
        prepareAudio(index)
        // Play current song
        playSong()
    }

    func playSong(index: Int)
    {
        // Verify if has a valid playlist to play
        if !songListIsValid() {
            return
        }
        // Prepare core audio
        prepareAudio(index)
        // Play current song
        playSong()
    }

    func pauseSong()
    {
        if audioPlayer!.playing {
            audioPlayer!.pause()
        }
    }

    func stopSong()
    {
        if audioPlayer == nil || !audioPlayer!.playing {
            return
        }

        audioPlayer!.stop();
        if let event = playerDidStop {
            event()
        }
        if let current = currentSong {
            prepareAudio(current, current.index)
        }
    }

    func playNextSong(stopIfInvalid: Bool = false)
    {
        if let songs = songsList {
            if let song = currentSong {
                var index = song.index

                // Next song
                index++

                if index > songs.count - 1 {
                    if stopIfInvalid {
                        stopSong()
                    }
                    return
                }

                playSong(index)
            }
        }
    }

    func playPreviousSong()
    {
        if let songs = songsList {
            if let song = currentSong {
                var index = song.index

                // Previous song
                index--

                if index < 0 {
                    return
                }

                playSong(index)
            }
        }
    }

    // isLastSong

    // isFirstSong
}

// MARK: AudioPlayerProtocol

extension AudioPlayer: AudioPlayerProtocol
{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool)
    {
        if !flag {
            return
        }
        playNextSong(stopIfInvalid: true)
    }
}
