//
//  NotificationDownload.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 03/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

class NotificationDownload: Notification
{
    var fileName: String = ""
    var progress: Float = 0 //0-1

    override init(_ message: String)
    {
        super.init(message)

    }
}
