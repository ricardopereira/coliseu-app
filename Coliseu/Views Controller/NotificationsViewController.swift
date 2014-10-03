//
//  NotificationsViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 25/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class NotificationsViewController: UIBaseViewController
{
    private let cellDownloadIdentifier = "CellDownload"

    // Outlets
    @IBOutlet weak var tableView: UITableView!

    // Model
    let controller: NotificationsController

    required init(nibName nibNameOrNil: String?, appCtrl: AppController)
    {
        controller = NotificationsController(appCtrl.data.remoteServer)
        super.init(nibName: nibNameOrNil, appCtrl: appCtrl)
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
        tableView.registerNib(cellNib!, forCellReuseIdentifier: cellDownloadIdentifier)
        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        // Dynamic cells
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        // Configure
        edgesForExtendedLayout = UIRectEdge.None
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.navigationBarHidden = false
        }
        // Get notifications from server
        controller.refresh(appCtrl.data.deviceToken!) { () -> () in
            self.tableView.reloadData()
        }
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        // Notification bar item
        if let barItem = tabBarItem {
            barItem.badgeValue = nil
        }
    }
}

extension NotificationsViewController: TableViewProtocol
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return controller.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cellRow = UITableViewCell()

        // Notification item
        let notify: AnyObject = controller.items[indexPath.row]

        // Check notification type
        if notify is NotificationDownload {
            // Download
            if let download = notify as? NotificationDownload {
                if let cell = tableView.dequeueReusableCellWithIdentifier(cellDownloadIdentifier) as DownloadViewCell? {
                    cellRow = cell.configure(download.message, download.fileName, download.progress)
                }
            }
        }
        else {
            // Information

        }
        return cellRow
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let notify: AnyObject = controller.items[indexPath.row]

        if notify is NotificationDownload {
            if let download = notify as? NotificationDownload
            {
                if download.progress == 1 {
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    return
                }

                let cell = tableView.cellForRowAtIndexPath(indexPath) as DownloadViewCell?
                if (cell == nil) {
                    return
                }

                // Download request
                appCtrl.data.remoteServer.download(download.fileName, appCtrl.data.deviceToken!,
                    progressEvent: { (totalBytesRead, totalBytesExpectedToRead) -> () in
                        // Update cell
                        let download = self.controller.items[indexPath.row] as NotificationDownload //?
                        // Workaround: maybe a bug from Swift!
                        download.progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)

                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell!.progressBar.progress = download.progress
                            cell!.progressBar.setNeedsDisplay()
                        })
                    },
                    completionRequest: { (error) -> () in
                        // Update cell
                        let download = self.controller.items[indexPath.row] as NotificationDownload //?
                        download.progress = 1

                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            tableView.beginUpdates()
                            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                            tableView.endUpdates()
                        })
                })
            }
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        // Test
        return 65
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        // Test
        return 65
    }
}
