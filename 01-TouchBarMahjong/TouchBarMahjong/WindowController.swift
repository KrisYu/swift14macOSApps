//
//  WindowController.swift
//  TouchBarMahjong
//
//  Created by Xue Yu on 6/21/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

fileprivate extension NSTouchBarItemIdentifier {
    static let flyPopover = NSTouchBarItemIdentifier("com.xueyu.flyPopover")
    static let flyLane = NSTouchBarItemIdentifier("com.xueyu.flyLane")
    static let luckyButton = NSTouchBarItemIdentifier("com.xueyu.luckyButton")
}

class WindowController: NSWindowController, NSTouchBarDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        
        let mainBar = NSTouchBar()
        mainBar.delegate = self
        mainBar.defaultItemIdentifiers = [.luckyButton, .flyPopover]
        return mainBar
    }
    
    @available(OSX 10.12.2, *)
    func makeFlyBar() -> NSTouchBar {
        let flyBar = NSTouchBar()
        flyBar.delegate = self
        flyBar.defaultItemIdentifiers = [.flyLane]
        return flyBar
    }
    

    func tapped(_ sender: NSButton) {
        
        let randomTile = Mahjong.generateRandomTile()
        sender.image = NSImage.init(named: randomTile + "@30px.png")
        
        if let frame = window?.contentView?.frame {
            
            let screenTile = NSImageView.init(frame: NSRect.init(x: frame.size.width/2 - 160, y: frame.size.height/2 - 64, width: 150, height: 128))
            screenTile.image = NSImage.init(named: randomTile + "@128px.png")
            
            
            let tileName = NSTextView.init(frame: NSRect.init(x: frame.size.width/2 + 60, y: frame.size.height/2 , width: 200, height: 24))
            tileName.string = randomTile
            tileName.isSelectable = false
            tileName.isEditable = false
            tileName.drawsBackground = false
            tileName.font = NSFont.systemFont(ofSize: 24)
            
            while (self.window?.contentView?.subviews.count)! > 0 {
                window?.contentView?.subviews.last?.removeFromSuperview()
            }
            
            self.window?.contentView?.addSubview(screenTile)
            self.window?.contentView?.addSubview(tileName)
        }
    }
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        switch identifier {
        case NSTouchBarItemIdentifier.flyPopover:
            
            let item = NSPopoverTouchBarItem(identifier: identifier)
            item.collapsedRepresentationLabel = "让麻将飞"
            item.popoverTouchBar = makeFlyBar()
            
            return item
        
        case NSTouchBarItemIdentifier.flyLane:
            
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.viewController = flyLaneVC()
            
            return item
        
        case NSTouchBarItemIdentifier.luckyButton:
            
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton.init(title: "🀄️", target: self, action: #selector(tapped(_ :)))
            
            item.view = button
            return item
            
        default:
            return nil
        }
    }
    

}
