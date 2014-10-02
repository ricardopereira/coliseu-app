//
//  StorageController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 02/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class StorageController
{
    init()
    {

    }

    func getLocalFiles() -> [AudioFile]
    {
        var files: [AudioFile] = []
        // Show files URLs
        forEachFile { (fileUrl) -> Bool in
            // Remove file
            files.append(AudioFile(url: fileUrl))
            return true
        }
        return files
    }

    func removeAllFiles()
    {
        // Show files URLs
        forEachFile { (fileUrl) -> Bool in
            // Remove file
            var error = NSErrorPointer()
            NSFileManager.defaultManager().removeItemAtURL(fileUrl, error: error)
            return true
        }
    }

    private func forEachFile(fileHandler: ((fileUrl: NSURL) -> Bool)) -> Bool
    {
        var result: Bool = false

        if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,inDomains: .UserDomainMask)[0] as? NSURL {
            var error = NSErrorPointer()

            let filesFromFolder = NSFileManager.defaultManager().contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, error: error)

            for file in filesFromFolder! {
                result = fileHandler(fileUrl: file as NSURL)
            }
        }
        return result
    }
}