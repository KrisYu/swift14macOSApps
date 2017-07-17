//
//  WindowController.swift
//  SlideMagic
//
//  Created by Xue Yu on 7/16/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        if let window = window, let screen = NSScreen.main() {
            let screenRect = screen.visibleFrame
            window.setFrame(NSRect.init(x: screenRect.origin.x,
                                        y: screenRect.origin.y,
                                        width: screenRect.width/2,
                                        height: screenRect.height), display: true)
        }
    }
    
    
    @IBAction func openAnotherFolder(_ sender: AnyObject)  {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles       = false
        openPanel.showsHiddenFiles     = false
        
        openPanel.beginSheetModal(for: self.window!) { (response) in
            guard response == NSFileHandlingPanelOKButton else { return }
            let viewController = self.contentViewController as? ViewController
            if let viewController = viewController,let URL = openPanel.url {
                viewController.loadDataForNewFolderWithUrl(URL)
            }
        }
    }

}
