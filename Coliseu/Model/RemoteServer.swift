//
//  RemoteServer.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 25/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import Alamofire

let api = "http://99.ip-5-196-8.eu:9000/api/"
let dir = "YouTube";

class RemoteServer: NotificationServerProtocol
{
    init()
    {

    }

    func submit(url: String, _ deviceToken: String)
    {
        if !feature_YouTube {
            return
        }

        let req = api + "submit?url=" + url + "&token=" + deviceToken

        // Submit a new download (audio file)
        Alamofire.request(.GET, req).responseString { (req: NSURLRequest, res: NSHTTPURLResponse?, str: String?, err: NSError?) -> Void in
            // Is alive
            if let res = str {
                println(res);
            }
        }
    }

    func download(fileName: String, _ deviceToken: String, progressEvent: (totalBytesRead: Int64, totalBytesExpectedToRead: Int64) -> (), completionRequest: (error: NSError?) -> ())
    {
        if !feature_YouTube {
            return
        }

        let url = api + "load?file=" + fileName + "&token=" + deviceToken

        // Download a audio file
        Alamofire.download(.GET, url, { (temporaryURL, response) in //Destination
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,inDomains: .UserDomainMask)[0] as? NSURL
            {
                let pathComponent = response.suggestedFilename
                return directoryURL.URLByAppendingPathComponent(pathComponent!)
            }
            return temporaryURL
        })
        .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            // Show the progress of download
            progressEvent(totalBytesRead: totalBytesRead, totalBytesExpectedToRead: totalBytesExpectedToRead)
        }
        .response { (request, response, _, error) in
            // Download is finished
            println(response)
            completionRequest(error: error)
        }
    }

    func getNotifications(deviceToken: String, completionRequest: (items: [AnyObject]) -> ()) //AnyObject -> base Notification
    {
        var list: [AnyObject] = []
        // Read notifications from server
        // WARNING: server must be scalable!
        Alamofire.request(.GET, api+"ready", parameters: ["token": deviceToken])
        .responseJSON { (_, _, JSON, _) in
            if let data = JSON as? NSArray
            {
                if data.count > 0
                {
                    for item in data {
                        let title = item["title"] as String!
                        let filename = item["filename"] as String!

                        list.append(NotificationDownload(title, filename))
                    }
                }
                completionRequest(items: list)
            }
        }
    }
}
