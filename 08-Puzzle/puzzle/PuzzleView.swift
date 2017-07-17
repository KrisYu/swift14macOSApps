//
//  PuzzleView.swift
//  puzzle
//
//  Created by Xue Yu on 6/29/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class PuzzleView: NSView {
    
    var boardSize: Int

    // let the dataSource provide the values
    var cells: [[Int]] {
        return dataSource!.cellsForPuzzle()
    }
    
    // ViewController will conforms to PuzzleDataSource protocol and provide dataSource for PuzzleView
    open var dataSource: PuzzleDataSource?
    
    convenience init(boardSize: Int) {
        self.init(frame: CGRect.zero)
        self.boardSize = boardSize
    }
    
    override init(frame frameRect: NSRect) {
        self.boardSize = 4
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var ratio: CGFloat {
        return CGFloat( 1 / Double(boardSize))
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.black.set()
        let boarderPath = NSBezierPath.init(rect: dirtyRect)
        boarderPath.lineWidth = 1
        boarderPath.stroke()
        
        getLines(dirtyRect).forEach { $0.stroke() }
        
        let attributes: [String: Any] = [NSForegroundColorAttributeName: NSColor.black,
                                         NSFontAttributeName: NSFont.init(name: "Menlo-Regular", size: 20)!]
        
        let w = dirtyRect.width
        let h = dirtyRect.height
        
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let str = NSAttributedString.init(string: String(cells[row][col]), attributes: attributes)
                
                str.draw(at: NSPoint.init(x: CGFloat(col) * ratio * w + w * (ratio/2) - str.size().width/2,
                                          y: CGFloat(row) * ratio * h + h * (ratio/2) - str.size().height/2))
                
                if str.string == "0" {
                    let rect = NSRect.init(x: CGFloat(col) * ratio * w + 0.5,
                                           y: CGFloat(row) * ratio * h + 0.5,
                                           width: CGFloat(w) * ratio - 1,
                                           height: CGFloat(h) * ratio - 1)
                    let path = NSBezierPath.init(rect: rect)
                    #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1).setFill()
                    path.fill()
                }
            }
        }
        
    }
    
    
    private func getLines(_ rect: NSRect) -> [NSBezierPath] {
        
        var lines = [NSBezierPath]()
        
        let w = rect.width
        let h = rect.height
        
        for i in 1..<boardSize {
            let path = NSBezierPath()
            path.move(to: NSPoint.init(x: CGFloat(i) * ratio * w, y: 0))
            path.line(to: NSPoint.init(x: CGFloat(i) * ratio * w, y: h))
            path.lineWidth = 1
            lines.append(path)
        }
        
        for i in 1..<boardSize {
            let path = NSBezierPath()
            path.move(to: NSPoint.init(x: 0, y: CGFloat(i) * ratio * h))
            path.line(to: NSPoint.init(x: w, y: CGFloat(i) * ratio * h))
            path.lineWidth = 1
            lines.append(path)
        }
        return lines
    }
    
    
}
