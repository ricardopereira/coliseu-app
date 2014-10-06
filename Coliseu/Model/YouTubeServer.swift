//
//  YouTubeServer.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 04/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import Alamofire

class YouTubeServer
{
    init()
    {

    }

    func getVideos(query: String, apiKey: String, completionRequest: (items: [YouTubeVideo]) -> ())
    {
        var list: [YouTubeVideo] = []

        let url = "https://www.googleapis.com/youtube/v3/search?part=id%2Csnippet&maxResults=25&q=cool+kids&type=video&fields=items(id%2FvideoId%2Csnippet%2Ftitle)&key=AIzaSyAph94YQOTuY4qqnKoSqIt2BM5MjsCFz0c"

        Alamofire.request(.GET, url)
            .responseJSON { (_, _, JSON, _) in
                println(JSON)

                if let data = JSON as? NSDictionary
                {
                    if let items = data["items"] as? NSArray
                    {
                        if items.count > 0
                        {
                            for item in items {
                                // Test
                                let id = (item["id"] as? NSDictionary)!["videoId"] as String!
                                let title = (item["snippet"] as? NSDictionary)!["title"] as String!

                                list.append(YouTubeVideo(id, title))
                            }
                        }
                    }
                    completionRequest(items: list)
                }
        }
    }
}
