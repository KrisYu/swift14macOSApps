//
//  ImageFile.swift
//  SlideMagic
//
//  Created by Xue Yu on 7/12/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class ImageFile {
    
    fileprivate(set) var thumbnail: NSImage?
    fileprivate(set) var fileName: String
    
    
    init?(url: URL) {
        fileName = url.lastPathComponent
        thumbnail = nil
        let imageSource = CGImageSourceCreateWithURL(url.absoluteURL as CFURL, nil)
        if let imageSource = imageSource {
            guard CGImageSourceGetType(imageSource) != nil else { return }
            let thumbnailOptions = [
                String(kCGImageSourceCreateThumbnailFromImageIfAbsent) : true,
                String(kCGImageSourceThumbnailMaxPixelSize) : 160
            ] as [String : Any]
            
            if let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary?) {
                thumbnail = NSImage(cgImage: thumbnailRef, size: NSSize.zero)
            } else {
                return nil
            }
        }
        
    }
}
