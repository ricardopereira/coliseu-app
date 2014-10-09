//
//  AppData.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import ColiseuPlayer

class AppData
{
    var deviceToken: String?

    // Remote server
    let remoteServer = RemoteServer()
    // Storage: Local, DropBox, ...
    private let storage = StorageController()

    init()
    {

    }

    func getLocalFiles() -> [AudioFile]
    {
        return storage.getLocalFiles()
    }
}