//
//  CollectionViewItem.swift
//  SlideMagic
//
//  Created by Xue Yu on 7/16/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    var imageFile: ImageFile? {
        didSet {
            guard isViewLoaded else { return }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
    
}
