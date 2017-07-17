//
//  BookCellView.swift
//  ORLYStore
//
//  Created by XueYu on 6/25/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class BookCellView: NSTableCellView {
    
    @IBOutlet weak var coverImage: NSImageView!
    @IBOutlet weak var bookTitle: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
