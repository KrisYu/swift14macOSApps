//
//  AppDelegate.swift
//  HideDesktop
//
//  Created by Xue Yu on 7/6/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    var desktopCreated = "unknown"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let button = statusItem.button
        button?.title = "🏈"
        
        let menu = NSMenu()
        let hideMenuItem = NSMenuItem.init(title: "Hide Desktop Files", action: #selector(toggleHideDesktopFiles(sender:)), keyEquivalent: "H")
        menu.addItem(hideMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem.init(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        
        
        // thx to https://stackoverflow.com/questions/412562/execute-a-terminal-command-from-a-cocoa-app/32240064#32240064
        // here I'm trying to read whether desktop is created now or not
        let pipe = Pipe()
        let task = Process()
        
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["read", "com.apple.finder", "CreateDesktop"]
        task.standardOutput = pipe
        
        let file = pipe.fileHandleForReading
        task.launch()
        desktopCreated = NSString.init(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue)! as String
        desktopCreated = desktopCreated.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // Desktop is Hide
        if desktopCreated == "false" {
            hideMenuItem.state = NSOnState
        }
        
        statusItem.menu = menu
        
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    
    func toggleHideDesktopFiles(sender: NSMenuItem) {
        let workTask = Process()
        workTask.launchPath = "/usr/bin/defaults"
        
        if desktopCreated == "true" {
            workTask.arguments = ["write", "com.apple.finder", "CreateDesktop", "false"]
            sender.state = NSOnState
            desktopCreated = "false"
        } else {
            workTask.arguments = ["write", "com.apple.finder", "CreateDesktop", "true"]
            sender.state = NSOffState
            desktopCreated = "true"
        }
        
        workTask.launch()
        workTask.waitUntilExit()
        let killtask = Process()
        killtask.launchPath = "/usr/bin/killall"
        killtask.arguments = ["Finder"]
        killtask.launch()
    }
    
    func quit() {
        NSApplication.shared().terminate(self)
    }



}

