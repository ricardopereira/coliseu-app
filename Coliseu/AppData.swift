//
//  AppData.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import Foundation

class AppData
{
    var deviceToken: String?

    let remoteServer = ServerController()
    // Files list
    var filesLocalStorage: [AudioFile] = []
    var filesReady: [AudioFile] {
        get { return remoteServer.filesToDownload }
    }

    init()
    {

    }
}