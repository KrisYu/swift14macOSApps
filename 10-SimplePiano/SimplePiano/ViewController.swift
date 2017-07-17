//
//  ViewController.swift
//  SimplePiano
//
//  Created by XueYu on 7/5/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa
import AVFoundation

fileprivate extension NSTouchBarItemIdentifier {
    static let touchC = NSTouchBarItemIdentifier("com.xueyu.touchC")
    static let touchD = NSTouchBarItemIdentifier("com.xueyu.touchD")
    static let touchE = NSTouchBarItemIdentifier("com.xueyu.touchE")
    static let touchF = NSTouchBarItemIdentifier("com.xueyu.touchF")
    static let touchG = NSTouchBarItemIdentifier("com.xueyu.touchG")
    static let touchA = NSTouchBarItemIdentifier("com.xueyu.touchA")
    static let touchB = NSTouchBarItemIdentifier("com.xueyu.touchB")
}

class ViewController: NSViewController, NSTouchBarDelegate {
    
    var ap: AVAudioPlayer!
    let soundDict = ["ド": "C", "レ": "D", "ミ": "E", "ファ": "F", "ソ": "G", "ラ": "A","シ": "B" ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func clickButton(_ sender: NSButton){
        playSound(sender: sender)
    }
    
    @objc
    func playSound(sender: NSButton) {
        
        guard let soundKey = soundDict[sender.title] else {
            return
        }
        
        guard let filePath = Bundle.main.path(forResource: soundKey, ofType: "mp3", inDirectory: "music") else {
            print("ha")

            return
        }
        let soundUrl = URL.init(fileURLWithPath: filePath)
        do {
            ap = try AVAudioPlayer.init(contentsOf: soundUrl)
            ap.play()
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let mainBar = NSTouchBar()
        mainBar.delegate = self
        mainBar.defaultItemIdentifiers = [.touchC, .touchD, .touchE, .touchF, .touchG, .touchA, .touchB]
        return mainBar
    }
    
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.touchC:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton.init(title: "ド", target: self, action: #selector(playSound(sender:)))
            item.view = button
            return item
        case NSTouchBarItemIdentifier.touchD:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton.init(title: "レ", target: self, action: #selector(playSound(sender:)))
            item.view = button
            return item
        case NSTouchBarItemIdentifier.touchE:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton.init(title: "ミ", target: self, action: #selector(playSound(sender:)))
            item.view = button
            return item
        case NSTouchBarItemIdentifier.touchF:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton.init(title: "ファ", target: self, action: #selector(playSound(sender:)))
            item.view = button
            return item
        case NSTouchBarItemIdentifier.touchG:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton.init(title: "ソ", target: self, action: #selector(playSound(sender:)))
            item.view = button
            return item
        case NSTouchBarItemIdentifier.touchA:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton.init(title: "ラ", target: self, action: #selector(playSound(sender:)))
            item.view = button
            return item
        case NSTouchBarItemIdentifier.touchB:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton.init(title: "シ", target: self, action: #selector(playSound(sender:)))
            item.view = button
            return item
        default:
            return nil
        }
    }
    
    
    deinit {
        self.view.window?.unbind(#keyPath(touchBar))
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if #available(OSX 10.12.1, *) {
            self.view.window?.unbind(#keyPath(touchBar)) // unbind first
            self.view.window?.bind(#keyPath(touchBar), to: self, withKeyPath: #keyPath(touchBar), options: nil)
        }
    }


}

