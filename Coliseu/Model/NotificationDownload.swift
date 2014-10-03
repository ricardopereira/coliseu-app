//
//  NotificationDownload.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 03/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

class NotificationDownload: Notification
{
    let fileName: String
    var progress: Float = 0 //0-1

    required init(_ message: String, _ fileName: String)
    {
        self.fileName = fileName
        super.init(message)
    }
}
