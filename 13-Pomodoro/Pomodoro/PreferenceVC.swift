//
//  PreferenceVC.swift
//  Pomodoro
//
//  Created by Xue Yu on 7/13/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class PreferenceVC: NSViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func dismissWindow(_ sender: Any) {
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    
    @IBAction func showLogFile(_ sender: Any) {
        guard let logPath = LogFile.filePath else { return }
        NSWorkspace.shared().openFile(logPath)
    }
    
    
  
    
    
    
}
