//
//  PlayerViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 22/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit
import ColiseuPlayer

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

        // ?
        // https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Remote-ControlEvents/Remote-ControlEvents.html#//apple_ref/doc/uid/TP40009541-CH7
        // Set itself as the first responder
        becomeFirstResponder()

        // Resign as first responder
        //resignFirstResponder();
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

    override func canBecomeFirstResponder() -> Bool
    {
        return true;
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .Default
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
}

