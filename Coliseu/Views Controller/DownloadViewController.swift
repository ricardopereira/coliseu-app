//
//  DownloadViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 25/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController
{
    let appCtrl: AppController
    private let cellIdentifier = "Cell"

    @IBOutlet weak var tableView: UITableView!

    required init(nibName nibNameOrNil: String?, appCtrl: AppController)
    {
        self.appCtrl = appCtrl
        super.init(nibName: nibNameOrNil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Register cell
        let cellNib = UINib(nibName: "DownloadViewCell", bundle: nil)
        tableView.registerNib(cellNib!, forCellReuseIdentifier: cellIdentifier)
        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        // Dynamic cells
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.navigationBarHidden = false
        }
        // Load list from server
        appCtrl.data.remoteServer.getNotifications(appCtrl.data.deviceToken!) { (response) -> () in
            self.tableView.reloadData()
        }
    }
}

extension DownloadViewController: TableViewProtocol
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return appCtrl.data.filesReady.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cellRow = UITableViewCell()

        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as DownloadViewCell? {
            let audioFile = appCtrl.data.filesReady[indexPath.row]
            cellRow = cell.configure(audioFile.title, audioFile.fileName, audioFile.progress)
        }
        return cellRow
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let audioFile = appCtrl.data.filesReady[indexPath.row]

        if audioFile.progress == 1 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }

        let cell = tableView.cellForRowAtIndexPath(indexPath) as DownloadViewCell?
        if (cell == nil) {
            return
        }

        appCtrl.data.remoteServer.download(audioFile.fileName, appCtrl.data.deviceToken!,
            progressEvent: { (totalBytesRead, totalBytesExpectedToRead) -> () in
                // Update cell
                let audioFile = self.appCtrl.data.filesReady[indexPath.row]
                // Workaround: maybe a bug from Swift!
                audioFile.progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell!.progressBar.progress = audioFile.progress
                    cell!.progressBar.setNeedsDisplay()
                })
            },
            completionRequest: { (error) -> () in
                // Update cell
                let audioFile = self.appCtrl.data.filesReady[indexPath.row]
                audioFile.progress = 1

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    tableView.beginUpdates()
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    tableView.endUpdates()
                })
            })

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 65
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 65
    }
}
