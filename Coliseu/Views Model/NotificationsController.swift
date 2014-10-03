//
//  NotificationsController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 02/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

class NotificationsController
{
    private var notifications: [AnyObject]?
    private let server: NotificationServerProtocol

    var items: [AnyObject] {
        if notifications == nil {
            // Zero notifications
            notifications = [Notification]()
        }
        return notifications!
    }

    init(_ server: NotificationServerProtocol)
    {
        self.server = server
    }

    func refresh(deviceToken: String, completion: () -> ())
    {
        // Load list from server
        server.getNotifications(deviceToken) { (list) -> () in
            self.notifications = list
            completion()
        }
    }

    func requestDownload(item: NotificationDownload)
    {

    }
}