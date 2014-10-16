//
//  SongsViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit
import ColiseuPlayer

class SongsViewController: UIBaseViewController
{
    private let cellSongIdentifier = "CellSong"
    // Files list
    private var files: [AudioFile]!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Register cell
        let cellNib = UINib(nibName: "SongViewCell", bundle: nil)
        tableView.registerNib(cellNib!, forCellReuseIdentifier: cellSongIdentifier)

        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self

        // Configure
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension

        // Teste
        let buttonSubmit = UIBarButtonItem(title: "YouTube", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didPressSubmit:"))
        navigationItem.rightBarButtonItem = buttonSubmit
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.navigationBarHidden = false
        }

        files = appCtrl.data.getLocalFiles()
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.hidesBarsOnSwipe = true
        }
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.hidesBarsOnSwipe = false
        }
    }

    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        // At this instance theres no Navigation bar!
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }

// MARK: Actions

    func didPressSubmit(sender: AnyObject?)
    {
        let alertController = UIAlertController(title: "YouTube to MP3", message: "search with:", preferredStyle: .Alert)

        let searchAction = UIAlertAction(title: "Search", style: .Default) { [unowned self] (_) in
            // Did press
            let urlTextField = alertController.textFields![0] as UITextField

            if feature_YouTube {
                // Search with YouTube API v3
                // Get result
                self.appCtrl.data.remoteServer.getVideos(urlTextField.text) { (items) -> () in
                    let videosView = VideosViewController(nibName: "VideosView", appCtrl: self.appCtrl, videos: items)
                    // Show results
                    if let navigation = self.navigationController {
                        navigation.pushViewController(videosView, animated: true)
                    }
                }
            }
        }
        searchAction.enabled = false

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }

        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "url"

            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                searchAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)

        self.presentViewController(alertController, animated: true) {
            // Completion
        }
    }
}

// MARK: - TableViewProtocol

extension SongsViewController: TableViewProtocol
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let filesList = files {
            return filesList.count
        }
        else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cellRow = UITableViewCell()

        if let filesList = files {
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellSongIdentifier) as SongViewCell? {
                let audioFile = filesList[indexPath.row]
                cellRow = cell.configure(audioFile.title, audioFile.fileName)
            }
        }
        return cellRow
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let filesList = files {
            appCtrl.player.playSong(indexPath.row, songsList: filesList)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let filesList = files {
                if let fileUrl = filesList[indexPath.row].path {
                    // Remove file - Model!!
                    appCtrl.data.removeFile(fileUrl)
                    files.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            }
        }
    }
}
