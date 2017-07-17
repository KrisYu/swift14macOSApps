//
//  AppDelegate.swift
//  TouchBarMahjong
//
//  Created by Xue Yu on 6/21/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.2, *) {
            NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
        } 
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

