//
//  puzzleWindow.swift
//  puzzle
//
//  Created by Xue Yu on 6/29/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class puzzleWindow: NSWindowController, PuzzleDataSource {
    
    let boardSize: Int
    var model: PuzzleBrain
    let puzzleView: PuzzleView
    
    required init?(coder: NSCoder) {
        boardSize = 4
        model = PuzzleBrain.init(size: boardSize)
        puzzleView = PuzzleView.init(boardSize: boardSize)
        
        super.init(coder: coder)
    }

    func cellsForPuzzle() -> [[Int]] {
        return model.cells
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        puzzleView.dataSource = self
        
        if let view = self.window?.contentView{
            let frame = NSRect.init(x: 20,
                                y: 20,
                                width: view.bounds.width - 40,
                                height: view.bounds.height - 40)
            
            model.shuffle()
            
            puzzleView.frame = frame
            view.addSubview(puzzleView)
            
        }
        
    }
    
    
    // puzzleView.display() redraws
    override func keyDown(with event: NSEvent) {

        switch event.keyCode {
        case 126:
            model.moveup()
            puzzleView.display()
        case 125:
            model.movedown()
            puzzleView.display()
        case 124:
            model.moveleft()
            puzzleView.display()
        case 123:
            model.moveright()
            puzzleView.display()
        default:
            break
        }
    }

}


protocol PuzzleDataSource {
    func cellsForPuzzle() -> [[Int]]
}
