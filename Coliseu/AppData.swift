//
//  AppData.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

class AppData
{
    var deviceToken: String?

    let remoteServer = ServerController()
    private let storage = StorageController()

    // Notifications
    var filesReady: [AudioFile] {
        get { return remoteServer.filesToDownload }
    }

    init()
    {

    }

    func getLocalFiles() -> [AudioFile]
    {
        return storage.getLocalFiles()
    }
}