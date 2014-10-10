//
//  VideosViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 06/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class VideosViewController: UIBaseViewController
{
    private let cellVideoIdentifier = "CellVideo"
    // Videos list
    let videos: [YouTubeVideo]

    @IBOutlet weak var tableView: UITableView!

    required init(nibName nibNameOrNil: String?, appCtrl: AppController, videos: [YouTubeVideo])
    {
        self.videos = videos
        super.init(nibName: nibNameOrNil, appCtrl: appCtrl)
    }

    required init(nibName nibNameOrNil: String?, appCtrl: AppController)
    {
        fatalError("init(nibName:appCtrl:) has not been implemented")
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad();
        // Register cell
        let cellNib = UINib(nibName: "VideoViewCell", bundle: nil)
        tableView.registerNib(cellNib!, forCellReuseIdentifier: cellVideoIdentifier)

        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension VideosViewController: TableViewProtocol
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return videos.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cellRow = UITableViewCell()

        if let cell = tableView.dequeueReusableCellWithIdentifier(cellVideoIdentifier) as VideoViewCell? {
            let item = videos[indexPath.row]
            cell.labelVideo.text = item.title
            cellRow = cell
        }
        return cellRow
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let item = videos[indexPath.row]

        let alertController = UIAlertController(title: nil, message: "YouTube to MP3", preferredStyle: .ActionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // Nothing
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Submit", style: .Default) { (action) in
            // Submit
            if let token = self.appCtrl.data.deviceToken {
                self.appCtrl.data.remoteServer.submit("http://youtu.be/" + item.videoId, token)
                // Notify to user
                self.statusNotification.displayNotificationWithMessage("Successfully submitted", duration: 1.0)
            }
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {

        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
