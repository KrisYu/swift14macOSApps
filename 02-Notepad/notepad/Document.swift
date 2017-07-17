//
//  Document.swift
//  notepad
//
//  Created by Xue Yu on 6/23/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    var val = ""
    

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
        
        let vc = windowController.contentViewController as! ViewController
        vc.textView.string = val
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        if let vc = self.windowControllers[0].contentViewController as? ViewController {
            return vc.textView.string?.data(using: String.Encoding.utf8) ?? Data()
        } else {
            return Data()
        }
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        if let s = String.init(data: data, encoding: .utf8) {
            val = s
        }
    }


}

