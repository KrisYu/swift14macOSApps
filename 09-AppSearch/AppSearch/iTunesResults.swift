//
//  iTunesResults.swift
//  AppSearch
//
//  Created by Xue Yu on 7/3/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class Result: NSObject {
    dynamic var rank = 0
    dynamic var artistName = ""
    dynamic var trackName = ""
    dynamic var averageUserRating = 0.0
    dynamic var averageUserRatingForCurrentVersion = 0.0
    dynamic var itemDescription = ""
    dynamic var price = 0.0
    dynamic var releaseDate = Date()
    dynamic var artworkURL: URL?
    dynamic var artworkImage: NSImage?
    dynamic var screenShotURLs: [URL] = []
    dynamic var screenShots = NSMutableArray()
    dynamic var userRatingCount = 0
    dynamic var userRatingForCurrentVersion = 0
    dynamic var primaryGenre = ""
    dynamic var fileSizeInBytes = 0
    dynamic var cellColor = NSColor.white
    
    init(dictionary: Dictionary<String, AnyObject>) {
        artistName = dictionary["artistName"] as! String
        trackName = dictionary["trackName"] as! String
        itemDescription = dictionary["description"] as! String
        primaryGenre = dictionary["primaryGenreName"] as! String
        
        if let uRatingCount = dictionary["userRatingCount"] as? Int {
            userRatingCount = uRatingCount
        }
        
        if let uRatingCountForCurrentVersion = dictionary["userRatingCountForCurrentVersion"] as? Int {
            userRatingForCurrentVersion = uRatingCountForCurrentVersion
        }
        
        if let averageRating = dictionary["averageUserRating"] as? Double {
            averageUserRating = averageRating
        }
        
        if let averageRatingForCurrent = dictionary["averageUserRatingForCurrentVersion"] as? Double {
            averageUserRatingForCurrentVersion = averageRatingForCurrent
        }
        
        if let fileSize = dictionary["fileSizeBytes"] as? String {
            if let fileSizeInt = Int(fileSize) {
                fileSizeInBytes = fileSizeInt
            }
        }
        
        if let appPrice = dictionary["price"] as? Double {
            price = appPrice
        }
        
        let formatter = DateFormatter()
        let enUSPosixLocale = NSLocale.init(localeIdentifier: "en_US_POSIX")
        formatter.locale = enUSPosixLocale as Locale!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        if let releaseDateString = dictionary["releaseDate"] as? String {
            releaseDate = formatter.date(from: releaseDateString)!
        }
        
        if let artURL = URL.init(string: dictionary["artworkUrl512"] as! String) {
            artworkURL = artURL
        }
        
        if let screenShotsArray = dictionary["screenshotUrls"] as? [String] {
            for screenShotURLString in screenShotsArray {
                if let screenShotURL = URL.init(string: screenShotURLString){
                    screenShotURLs.append( screenShotURL)
                }
            }
        }
        super.init()
    }
    
    
    func loadIcon(){
        guard let artworkURL = artworkURL else { return }
        
        if artworkImage != nil {
            return
        }
        
        iTunesRequestManager.downloadImage(artworkURL) { (image, error) in
            DispatchQueue.main.async(execute: { 
                self.artworkImage = image
            })
        }
    }
    
    func loadScreenShots() {
        if screenShots.count > 0 {
            return
        }
        
        for sceenShotURL in screenShotURLs {
            iTunesRequestManager.downloadImage(sceenShotURL, completionHandler: { (image, error) in
                DispatchQueue.main.async(execute: { 
                    guard let image = image, error == nil else {
                        return
                    }
                    
                    self.willChangeValue(forKey: "screenShots")
                    self.screenShots.add(image)
                    self.didChangeValue(forKey: "screenShots")
                })
            })
        }
    }
    
    override var description: String {
        get {
            return "artist: \(artistName) track: \(trackName) average rating: \(averageUserRating) price:\(price) release date: \(releaseDate) rank: \(rank)"
        }
    }
    
    
    
}
