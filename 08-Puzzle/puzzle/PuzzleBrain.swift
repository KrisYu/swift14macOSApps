//
//  PuzzleBrain.swift
//  puzzle
//
//  Created by Xue Yu on 6/29/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Foundation


struct PuzzleBrain {
    
    struct Tile {
        var row: Int
        var col: Int
    }
    
    var boardSize = 4
    var cells: [[Int]]
    var zero: Tile
    
    
    init(size boardSize: Int) {
        self.boardSize = boardSize
        cells = Array(repeating: Array(repeating: 0, count: boardSize), count: boardSize)
        zero = Tile.init(row: 0, col: 0)
        reset()
    }
    

    mutating func reset() {
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                cells[row][col] = row * boardSize + col + 1
            }
        }
        
        cells[boardSize - 1][boardSize - 1] = 0
        zero = Tile.init(row: boardSize - 1, col: boardSize - 1)
    }
    
    
    // MARK:  move zero tile around
    mutating func moveup(){
        if zero.row != 0 {
            let tmp = cells[zero.row-1][zero.col]
            cells[zero.row-1][zero.col] = 0
            cells[zero.row][zero.col] = tmp
            zero.row -= 1
        }
    }
    
    mutating func movedown(){
        if zero.row != cells.count - 1 {
            let tmp = cells[zero.row+1][zero.col]
            cells[zero.row+1][zero.col] = 0
            cells[zero.row][zero.col] = tmp
            zero.row += 1
        }
    }
    
    
    mutating func moveright(){
        if zero.col != cells[0].count - 1 {
            let tmp = cells[zero.row][zero.col+1]
            cells[zero.row][zero.col+1] = 0
            cells[zero.row][zero.col] = tmp
            zero.col += 1
        }
    }
    
    
    mutating func moveleft(){
        if zero.col != 0 {
            let tmp = cells[zero.row][zero.col-1]
            cells[zero.row][zero.col-1] = 0
            cells[zero.row][zero.col] = tmp
            zero.col -= 1
        }
    }
    
    
    

    mutating func shuffle(steps: Int = 100)  {
        for _ in 0..<steps {
            let direction = arc4random_uniform(UInt32.init(4))
            switch direction {
            case 0:
                moveup()
            case 1:
                movedown()
            case 2:
                moveleft()
            case 3:
                moveright()
            default:
                break
            }
        }
    }
    
    func isGoal() -> Bool {
        var counter = 1
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                var value = cells[row][col]
                value = value == 0 ? boardSize * boardSize : value
                if value == counter {
                    counter += 1
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    
    
}
