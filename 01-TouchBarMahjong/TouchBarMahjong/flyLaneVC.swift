//
//  flyLaneVC.swift
//  TouchBarMahjong
//
//  Created by Xue Yu on 6/21/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

struct Mahjong {

    static func generateRandomTile() -> String {
        let MahjongTiles = ["bamboo1", "bamboo2", "bamboo3", "bamboo4", "bamboo5", "bamboo6", "bamboo7", "bamboo8", "bamboo9", "man1", "man2", "man3", "man4", "man5", "man6", "man7", "man8", "man9","pin1", "pin2", "pin3", "pin4", "pin5", "pin6", "pin7", "pin8", "pin9","wind-east", "wind-north", "wind-south", "wind-west","dragon-chun"
            ,"dragon-green","dragon-haku"]
        
        let randomIndex = Int(arc4random_uniform(UInt32(MahjongTiles.count)))
        return MahjongTiles[randomIndex]
    }
    
}

class flyLaneVC: NSViewController {
    
    let lane = NSView()
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidAppear() {
        lane.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width * 2, height: self.view.frame.height)
        lane.layer?.position = CGPoint.init(x: 0, y: 0)
        self.view.addSubview(lane)
        
        for x in 0...16 {
            lane.addSubview(makeTile(x: x * 100))
        }
        
        start()
    }
    
    func makeTile(x: Int) -> NSView {
        
//        let tile = NSTextView.init(frame: NSRect.init(x: x, y: 0, width: 30, height: 30))
//        tile.string = "🀄️"
//        tile.drawsBackground = false
//        tile.isEditable = false
//        tile.isSelectable = false
//        tile.font = NSFont.systemFont(ofSize: 20)
        let tile = NSImageView.init(frame: NSRect.init(x: x, y: 0, width: 30, height: 30))
        let tileName = Mahjong.generateRandomTile() + "@30px.png"
        
        tile.image = NSImage.init(named: tileName)
        return tile
    }
    
    
    func start() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.repeatCount = .infinity
        animation.duration = 8
        animation.fromValue = lane.layer?.position
        animation.toValue = NSValue.init(point: NSPoint.init(x: -self.view.frame.width, y: 0))
        lane.layer?.add(animation, forKey: "position")
        
//        let animation2 = CABasicAnimation(keyPath: "opacity")
//        animation2.fromValue = 0
//        animation2.toValue = 1
//        animation2.duration = 3
//        lane.layer?.add(animation2, forKey: "opacity")
    }
}
