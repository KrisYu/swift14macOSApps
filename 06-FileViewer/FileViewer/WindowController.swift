//
//  WindowController.swift
//  FileViewer
//
//  Created by Xue Yu on 6/27/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBAction func openDocument(_ sender: NSMenuItem) {
        
        let openPanel = NSOpenPanel()
        openPanel.showsHiddenFiles = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        
        openPanel.beginSheetModal(for: self.window!) { response in
            guard response == NSFileHandlingPanelOKButton else {
                return
            }
            
            self.contentViewController?.representedObject = openPanel.url
        }
    }


}
