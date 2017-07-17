//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Xue Yu on 6/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var operations: Dictionary<String,Operation> = [
        "E" : Operation.constant(M_E),
        "*" : Operation.binaryOperation{ $0 * $1 },
        "/" : Operation.binaryOperation{ $0 / $1 },
        "+" : Operation.binaryOperation{ $0 + $1 },
        "-" : Operation.binaryOperation{ $0 - $1 },
        "=" : Operation.equals
        ]
    
    enum Operation {
        case constant(Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private mutating func performBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation.init(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performBinaryOperation()
        
            }
        }
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func reset() {
        pendingBinaryOperation = nil
        accumulator = nil
    }
    
    
    
}
