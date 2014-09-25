//
//  DataProvider.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 25/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit
import Alamofire

let api = "http://99.ip-5-196-8.eu:9000/api/"
let dir = "YouTube";

class ServerController
{
    var filesToDownload: [AudioFile] = []

    init()
    {

    }

    func submit(url: String, _ deviceToken: String)
    {
        let url = api + "submit?url=" + url + "&token=" + deviceToken

        Alamofire.request(.GET, url).responseString { (req: NSURLRequest, res: NSHTTPURLResponse?, str: String?, err: NSError?) -> Void in
            // Is alive
            println(str!);
        }
    }

    func download(fileName: String)
    {
        Alamofire.download(.GET, api + "load?file=" + fileName, { (temporaryURL, response) in //Destination
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,inDomains: .UserDomainMask)[0] as? NSURL
            {
                NSLog("Suggested %@%@",directoryURL.absoluteString!,response.suggestedFilename!)

                let pathComponent = response.suggestedFilename
                return directoryURL.URLByAppendingPathComponent(pathComponent!)
            }
            return temporaryURL
        })
        .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            println(totalBytesRead)
        }
    }

    func downloadAll()
    {
        // Download all of the files
        for data in filesToDownload {
            download(data.fileName)
        }
        filesToDownload.removeAll(keepCapacity: false)
    }

    func getNotifications(deviceToken: String, completionRequest: (sender: AnyObject?) -> ())
    {
        Alamofire.request(.GET, api+"ready", parameters: ["token": deviceToken])
        .responseJSON { (_, _, JSON, _) in
            if let data = JSON as? NSArray {
                if data.count > 0 {
                    self.filesToDownload.removeAll(keepCapacity: false)
                    for item in data {
                        let title = item["title"] as String!
                        let filename = item["filename"] as String!

                        self.filesToDownload.append(AudioFile(title, filename))
                    }
                    completionRequest(sender: JSON)
                }
            }
        }
    }
}
