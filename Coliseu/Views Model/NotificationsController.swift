//
//  NotificationsController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 02/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

class NotificationsController
{
    private var notifications: [Notification] = []
    private let server: NotificationServerProtocol

    var items: [Notification] {
        return notifications
    }

    init(_ server: NotificationServerProtocol)
    {
        self.server = server
    }

    func refresh()
    {

    }

    func requestDownload(item: NotificationDownload)
    {

    }
}