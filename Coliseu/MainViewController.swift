//
//  ViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 22/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit
import Alamofire

let api = "http://99.ip-5-196-8.eu:9000/api"
let dir = "YouTube";

class MainViewController: UIViewController
{
    var player: AudioPlayer?;
    var memData: AppData?
    var deviceToken: String?

    @IBOutlet weak var fieldUrl: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var buttonRemoveAll: UIButton!
    @IBOutlet weak var buttonShowFiles: UIButton!

    override func loadView()
    {
        super.loadView()
        //self.view = MainView(frame: UIScreen.mainScreen().bounds)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        player = AudioPlayer()

        // Show files URLs
        forEachFile { (fileUrl) -> Bool in
            NSLog("%@",fileUrl.absoluteString!)

            self.player!.audioList.append(fileUrl)
            return true;
        }

        refreshView()

        // View targets
        buttonSubmit.addTarget(self, action: "didPressButtonSubmit:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonPlay.addTarget(self, action: "didPressButtonPlay:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonStop.addTarget(self, action: "didPressButtonStop:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonRemoveAll.addTarget(self, action: "didPressButtonRemoveAll:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonShowFiles.addTarget(self, action: "didPressButtonShowFiles:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated);

        for data in memData!.filesToDownload {
            download(data)
        }
        memData!.filesToDownload.removeAll(keepCapacity: false)

        // Remover o ficheiro que já fez o download com sucesso
        // Melhorar o refrescamento

        if let lastFileUrl = player!.audioList.last as NSURL? {
            player!.prepareAudio(lastFileUrl)
        }

        refreshView()
    }

    func refreshView()
    {
        buttonPlay.enabled = player!.audioList.count > 0
        buttonPlay.setNeedsDisplay()
        view.setNeedsDisplay()
    }

// MARK: Files

    func forEachFile(fileHandler: ((fileUrl: NSURL) -> Bool)) -> Bool
    {
        var result: Bool = false

        if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,inDomains: .UserDomainMask)[0] as? NSURL {
            var error = NSErrorPointer()

            let filesFromFolder = NSFileManager.defaultManager().contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, error: error)

            for file in filesFromFolder! {
                result = fileHandler(fileUrl: file as NSURL)
            }
        }
        return result
    }

    func download(fileName: String)
    {
        Alamofire.download(.GET, api + "/load?file=" + fileName, { (temporaryURL, response) in //Destination
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,inDomains: .UserDomainMask)[0] as? NSURL
            {
                NSLog("Suggested %@%@",directoryURL.absoluteString!,response.suggestedFilename!)

                let pathComponent = response.suggestedFilename
                return directoryURL.URLByAppendingPathComponent(pathComponent!)
            }
            return temporaryURL
        })
        .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            println(totalBytesRead)
        }
        .response { (request, response, _, error) in

        }
    }

// MARK: Actions

    func didPressButtonSubmit(sender: AnyObject?)
    {
        if (deviceToken == nil) {
            return;
        }

        let url = api + "/submit?url=" + fieldUrl.text + "&token=" + deviceToken!

        Alamofire.request(.GET, url).responseString { (req: NSURLRequest, res: NSHTTPURLResponse?, str: String?, err: NSError?) -> Void in
            // Is alive
            println(str!);
        }
    }

    func didPressButtonPlay(sender: AnyObject?)
    {
        if let lastFileUrl = player!.audioList.last as NSURL? {
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            if player!.audioPlayer.playing {
                player!.pauseAudio();
            } else {
                player!.playAudio()
            }
        }
    }

    func didPressButtonStop(sender: AnyObject?)
    {
        if let firstFileUrl = player!.audioList.first as NSURL? {
            player!.stopAudio()
            // Teste
            if let lastFileUrl = player!.audioList.last as NSURL? {
                player!.prepareAudio(lastFileUrl)
            }
            UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        }
    }

    func didPressButtonRemoveAll(sender: AnyObject?)
    {
        // Show files URLs
        forEachFile { (fileUrl) -> Bool in
            // Remove file
            var error = NSErrorPointer()
            NSFileManager.defaultManager().removeItemAtURL(fileUrl, error: error)
            return true
        }
        refreshView()
    }

    func didPressButtonShowFiles(sender: AnyObject?)
    {
        var files: [NSURL] = []
        // Show files URLs
        forEachFile { (fileUrl) -> Bool in
            // Remove file
            var error = NSErrorPointer()
            files.append(fileUrl)
            return true
        }

        let filesView = FilesViewController(nibName: "FilesView", bundle: nil)
        filesView.files = files
        self.navigationController!.pushViewController(filesView, animated: true)
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
                didPressButtonPlay(nil)
            case UIEventSubtype.RemoteControlPause:
                player!.pauseAudio();
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

