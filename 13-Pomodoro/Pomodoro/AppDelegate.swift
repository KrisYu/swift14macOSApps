//
//  AppDelegate.swift
//  Pomodoro
//
//  Created by Xue Yu on 7/12/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

enum PomodoroMode: String {
    case Work = "👔"
    case Break = "☕️"
    case LongBreak = "😴"
    case Disabled = "🍅"
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let menu = NSMenu()
    let workTime = 25 * 60.0
    let breakTime = 5 * 60.0
    let longBreakTime = 15 * 60.0
    let longBreakInterval = 4
    let showSeconds = true
    let completedCountMenu = NSMenuItem.init(title: "Completed: 0", action: nil, keyEquivalent: "")
    var alreadycompletedPomodoros = 0
    var completedPomodoros = 0
    var startedSectionAt = 0
    var countdownUtil = Date()
    var currentMode = PomodoroMode.Disabled
    var currentTimer = Timer()
    var userNotifications = NSUserNotificationCenter.default
    var notificationCenter = NotificationCenter.default
        
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateMenuText()
        menu.addItem(NSMenuItem.init(title: "👔 Work", action: #selector(startWorkMode), keyEquivalent: "s"))
        menu.addItem(NSMenuItem.init(title: "☕️ Break", action: #selector(startBreakMode), keyEquivalent: "b"))
        menu.addItem(NSMenuItem.init(title: "🔌 Disable", action: #selector(startDisableMode), keyEquivalent: "d"))

        alreadycompletedPomodoros = LogFile.readFromLog(date: Date())
        completedPomodoros = alreadycompletedPomodoros
        updateCompletedItemText()

        menu.addItem(NSMenuItem.separator())
        menu.addItem(completedCountMenu)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem.init(title: "Preference", action: #selector(preference), keyEquivalent: ","))
        menu.addItem(NSMenuItem.init(title: "Quit", action: #selector(terminate), keyEquivalent: "q"))
        
        statusItem.menu = menu
        userNotifications.delegate = self
        

    }
    
    func preference() {
        
        let storyboard = NSStoryboard.init(name: "Main", bundle: nil)
        let preferenceWC = storyboard.instantiateController(withIdentifier: "PreferenceWindow") as! NSWindowController
        
        if let preferenceWindow = preferenceWC.window {
            let preferenceView = preferenceWindow.contentViewController as! PreferenceVC

            let application = NSApplication.shared()
            application.runModal(for: preferenceWindow)
            
            preferenceWindow.makeKeyAndOrderFront(nil)
            
            preferenceWindow.close()
        }
        
        

        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func updateMenuText() {
        if let button = statusItem.button {
            let timeLeftInMode = stringFromTimeInterval(countdownUtil.timeIntervalSinceNow)
            button.title = "\(currentMode.rawValue) \(timeLeftInMode)"
        }
    }
    
    func startWorkMode(_ sender: AnyObject) {
        ensureTimer()
        currentMode = .Work
        countdownUtil = Date.init(timeIntervalSinceNow: workTime)
        showNotification("Work time!")
        updateMenuText()
    }
    
    func startLongBreakMode(_ sender: AnyObject) {
        ensureTimer()
        currentMode = .LongBreak
        countdownUtil = Date.init(timeIntervalSinceNow: longBreakTime)
        showNotification("Long Break time!")
        updateMenuText()
    }
    
    func startBreakMode(_ sender: AnyObject) {
        ensureTimer()
        currentMode = .Break
        countdownUtil = Date.init(timeIntervalSinceNow: breakTime)
        showNotification("Break time!")
        updateMenuText()
    }
    
    func startDisableMode(_ sender: AnyObject) {
        currentTimer.invalidate()
        currentMode = .Disabled
        countdownUtil = Date()
        updateMenuText()
    }
    
    
    func showNotification(_ text: String) {
        let notification = NSUserNotification()
        notification.identifier = "com.xueyu.Pomodoro-notification"
        notification.title = "Pomodoro"
        notification.subtitle = "\(currentMode.rawValue) \(text)"
        notification.soundName = NSUserNotificationDefaultSoundName
        
        userNotifications.deliver(notification)
    }
    
    func ensureTimer() {
        if !currentTimer.isValid {
            currentTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateMenuTextFromTimer), userInfo: nil, repeats: true)
            currentTimer.tolerance = 0.5
        }
    }
    
    
    func updateMenuTextFromTimer(_ sender: AnyObject) {
        let timeLeftInMode = countdownUtil.timeIntervalSinceNow
        
        if timeLeftInMode <= 0 {
            if currentMode == .Break || currentMode == .LongBreak {
                startWorkMode("" as AnyObject)
            } else {
                completedPomodoro()
            }
        } else {
            updateMenuText()
        }
    }
    
    func completedPomodoro() {
        completedPomodoros += 1
        
        updateCompletedItemText()
        
        if completedPomodoros % longBreakInterval == 0 {
            startLongBreakMode("" as AnyObject)
        } else {
            startBreakMode("" as AnyObject)
        }
    }
    
    func updateCompletedItemText(){
        LogFile.writeToLog(date: Date(), finish: completedPomodoros)
        completedCountMenu.title = "Completed: \(completedPomodoros)"
    }
    

    
    //https://stackoverflow.com/questions/28872450/conversion-from-nstimeinterval-to-hour-minutes-seconds-milliseconds-in-swift/28872601#28872601
    func stringFromTimeInterval(_ interval: TimeInterval) -> NSString {
        if interval < 1.0 { return "" }
        
        let intervalAsInteger = Int(interval)
        let seconds = intervalAsInteger % 60
        let minutes = Int(showSeconds ?
            (intervalAsInteger / 60) % 60 :
            Int(round(interval / 60.0)) % 60 )
        
        if showSeconds {
            return NSString(format: "%0.2d:%0.2d", minutes, seconds)
        } else {
            return NSString(format: "%0.1d", minutes)
        }
    }
    

    
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }


    // save as log file before exit
    func terminate()  {
        LogFile.writeToLog(date: Date(), finish: completedPomodoros)
        NSApplication.shared().terminate(self)
    }

    
}

