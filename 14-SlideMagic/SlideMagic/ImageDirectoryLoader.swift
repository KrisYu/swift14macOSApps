//
//  ImageDirectoryLoader.swift
//  SlideMagic
//
//  Created by Xue Yu on 7/16/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class ImageDirectoryLoader: NSObject {
    
    fileprivate var imageFiles = [ImageFile]()
    
    func setupDataForUrls(_ urls: [URL]?) {
        
        if let urls = urls { //new folder
            createImageFilesFolder(urls)
        }
        
    }
    
    
    func numberOfItems() -> Int {
        return imageFiles.count
    }
    
    func createImageFilesFolder(_ urls: [URL]) {
        if imageFiles.count > 0 {  // not initial folder
            imageFiles.removeAll()
        }
        
        for url in urls {
            if let imageFile = ImageFile(url: url){
                imageFiles.append(imageFile)
            }
        }
    }
    
    fileprivate func getFilesURLFromFolder(_ folderURL: URL) -> [URL]? {
        
        let options : FileManager.DirectoryEnumerationOptions = [ .skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
        let fileManager = FileManager.default
        let resourceValueKeys = [URLResourceKey.isRegularFileKey, URLResourceKey.typeIdentifierKey]
        
        guard let directoryEnumerator = fileManager.enumerator(at: folderURL,
                                                               includingPropertiesForKeys: resourceValueKeys,
                                                               options: options,
                                                               errorHandler: { url, error in
            print("`directoryEnumerator` error : \(error)")
            return true
        }) else { return nil }
        
        var urls: [URL] = []
        
        for case let url as URL in directoryEnumerator {
            do {
                let resourceValues = try (url as NSURL).resourceValues(forKeys: resourceValueKeys)
                guard let isReuglarFileResourceValue = resourceValues[URLResourceKey.isRegularFileKey] as? NSNumber else { continue }
                guard isReuglarFileResourceValue.boolValue else { continue }
                guard let fileType = resourceValues[URLResourceKey.typeIdentifierKey] as? String else { continue }
                guard UTTypeConformsTo(fileType as CFString, "public.image" as CFString) else { continue }
                urls.append(url)
            } catch  {
                print("Unexpected error occured: \(error).")
            }
        }
        return urls
    }
    
    func imageFileForIndexPath(_ indexPath: IndexPath) -> ImageFile {
        let imageIndexInImageFiles = indexPath.item
        let imageFile = imageFiles[imageIndexInImageFiles]
        return imageFile
    }
    
    func loadDataForFolderWithUrl(_ folderURL: URL)  {
        let urls = getFilesURLFromFolder(folderURL)
        if let urls = urls {
            print("\(urls.count) images fond in directory \(folderURL.lastPathComponent)")
            for url in urls {
                print("\(url.lastPathComponent)")
            }
        }
        setupDataForUrls(urls)
    }

}
