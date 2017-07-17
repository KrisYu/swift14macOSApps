//
//  iTunesRequestManager.swift
//  AppSearch
//
//  Created by Xue Yu on 7/3/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

struct iTunesRequestManager {
    static func getSearchResults(_ query: String, results: Int, langString: String, completionHandler: @escaping ([[String: AnyObject]], NSError?) -> Void) {
        var urlComponents = URLComponents.init(string: "https://itunes.apple.com/search")
        let termQueryItem = URLQueryItem.init(name: "term", value: query)
        let limitQueryItem = URLQueryItem.init(name: "limit", value: "\(results)")
        let mediaQueryItem = URLQueryItem.init(name: "media", value: "software")
        urlComponents?.queryItems = [termQueryItem, limitQueryItem, mediaQueryItem]
        
        guard let url = urlComponents?.url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler([],nil)
                return
            }
            
            do {
                guard let itunesData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                    completionHandler([], nil)
                    return
                }
                if let results = itunesData["results"] as? [[String: AnyObject]] {
                    completionHandler(results, nil)
                } else {
                    completionHandler([], nil)
                }
            } catch _ {
                completionHandler([], error as NSError?)
            }
        }
        task.resume()
    }
    
    
    static func downloadImage(_ imageURL: URL, completionHandler: @escaping(NSImage?, NSError?) -> Void) {
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil, error as NSError?)
                return
            }
            let image = NSImage.init(data: data)
            completionHandler(image,nil)
        }
        task.resume()
    }
}
