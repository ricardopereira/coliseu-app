//
//  PlayerViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 22/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class PlayerViewController: UIBaseViewController
{
    // Outlets
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var buttonPrev: UIButton!
    @IBOutlet weak var buttonNext: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configurePlayer()

        refreshView()

        // View targets = Events
        buttonPlay.addTarget(self, action: "didPressPlay:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonStop.addTarget(self, action: "didPressStop:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonPrev.addTarget(self, action: "didPressPrevious:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonNext.addTarget(self, action: "didPressNext:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated);
        refreshView()
    }

    override func viewWillAppear(animated: Bool)
    {
        configureView()
    }

// MARK: View

    func configurePlayer()
    {
        appCtrl.player.startSession()

        // Player
        appCtrl.player.playerDidStart = { () -> () in
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        }
        appCtrl.player.playerDidStop = { () -> () in
            UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        }
    }

    func configureView()
    {
        // Navigation
        if let navigation = navigationController {
            navigation.navigationBarHidden = true
        }
    }

    func refreshView()
    {

        view.setNeedsDisplay()
    }

// MARK: Actions

    func didPressPlay(sender: AnyObject?)
    {
        appCtrl.player.playSong();
    }

    func didPressStop(sender: AnyObject?)
    {
        appCtrl.player.stopSong();
    }

    func didPressPrevious(sender: AnyObject?)
    {
        appCtrl.player.playPreviousSong();
    }

    func didPressNext(sender: AnyObject?)
    {
        appCtrl.player.playNextSong();
    }

// MARK: Remote

    override func remoteControlReceivedWithEvent(event: UIEvent)
    {
        if event.type == UIEventType.RemoteControl {
            switch event.subtype {
            case UIEventSubtype.RemoteControlNextTrack:
                appCtrl.player.playNextSong();
            case UIEventSubtype.RemoteControlPreviousTrack:
                appCtrl.player.playPreviousSong();
            case UIEventSubtype.RemoteControlPlay:
                appCtrl.player.playSong();
            case UIEventSubtype.RemoteControlPause:
                appCtrl.player.pauseSong();
            default:
                appCtrl.player.playSong();
            }
        }
    }
}

