//
//  AudioFile.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 24/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit
// ? - Teste for MetaData
import AVFoundation

class AudioFile
{
    let title: String
    let fileName: String
    var fileSize: Int = 0
    var length: Float = 0.0
    var path: NSURL?

    required init(_ title: String, _ fileName: String)
    {
        self.title = title
        self.fileName = fileName
    }

    convenience init(url: NSURL)
    {
        let fileAsset = AVURLAsset(URL: url, options: nil)
        var title: String = "Mp3"

        // ToDo:
        for metadataFormat in fileAsset.availableMetadataFormats {
            if let metadataList = fileAsset.metadataForFormat(metadataFormat as String) {
                for metadataItem in metadataList
                {
                    if metadataItem.commonKey == nil {
                        continue
                    }
                    let commonKey = metadataItem.commonKey!

                    if commonKey == nil {
                        continue
                    }

                    switch commonKey! {
                    case "artword":
                        NSLog("Artwork")
                    case "title":
                        title = metadataItem.value!!
                    default:
                        NSLog("none")
                    }
                }
            }
        }

        self.init(title, url.lastPathComponent)
        path = url
    }
}
