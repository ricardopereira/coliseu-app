//
//  NotificationServerProtocol.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 03/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

protocol NotificationServerProtocol
{
    func getNotifications(deviceToken: String, completionRequest: (items: [AnyObject]) -> ())
}
