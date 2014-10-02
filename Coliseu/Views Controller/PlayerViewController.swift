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
    @IBOutlet weak var fieldUrl: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var buttonRemoveAll: UIButton!
    @IBOutlet weak var buttonShowFiles: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configurePlayer()

        refreshView()

        // View targets = Events
        buttonSubmit.addTarget(self, action: "didPressSubmit:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonPlay.addTarget(self, action: "didPressPlay:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonStop.addTarget(self, action: "didPressStop:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonRemoveAll.addTarget(self, action: "didPressDownloadFiles:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonShowFiles.addTarget(self, action: "didPressShowFiles:", forControlEvents: UIControlEvents.TouchUpInside)
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
        //buttonPlay.enabled = player.audioList.count > 0

        buttonPlay.setNeedsDisplay()
        view.setNeedsDisplay()
    }

// MARK: Actions

    func didPressSubmit(sender: AnyObject?)
    {
        if appCtrl.data.deviceToken == nil {
            return
        }
        appCtrl.data.remoteServer.submit(fieldUrl.text, appCtrl.data.deviceToken!)
    }

    func didPressPlay(sender: AnyObject?)
    {

    }

    func didPressStop(sender: AnyObject?)
    {

    }

    func didPressRemoveAll(sender: AnyObject?)
    {

        refreshView()
    }

    func didPressShowFiles(sender: AnyObject?)
    {

    }

    func didPressDownloadFiles(sender: AnyObject?)
    {
        let notificationsView = DownloadViewController(nibName: "DownloadView", appCtrl: appCtrl)
        navigationController!.pushViewController(notificationsView, animated: true)
    }

// MARK: Remote

    override func remoteControlReceivedWithEvent(event: UIEvent)
    {
        if event.type == UIEventType.RemoteControl {
            switch event.subtype {
            case UIEventSubtype.RemoteControlNextTrack:
                NSLog("Next track")
            case UIEventSubtype.RemoteControlPreviousTrack:
                NSLog("Prev track")
            case UIEventSubtype.RemoteControlPlay:
                appCtrl.player.playAudio();
            case UIEventSubtype.RemoteControlPause:
                appCtrl.player.pauseAudio();
            default:
                NSLog("Pause/Play")
            }
        }
    }

    override func canBecomeFirstResponder() -> Bool
    {
        return true
    }

}

