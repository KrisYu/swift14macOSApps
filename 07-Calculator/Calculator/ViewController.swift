//
//  ViewController.swift
//  Calculator
//
//  Created by Xue Yu on 6/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var display: NSTextField!
    
    var userInTheMiddleOfTyping = false
    
    
    @IBAction func touchDigit(_ sender: NSButton) {
        let digit = sender.title
        let textCurrentlyInDisplay = display.stringValue
        
        if userInTheMiddleOfTyping {
            display.stringValue = textCurrentlyInDisplay + digit
        } else {
            display.stringValue = digit
            userInTheMiddleOfTyping = true
        }
    }
    
    // computed property
    var displayValue: Double {
        get {
            return Double(display.stringValue)!
        }
        
        set {
            
            // display Int vs Double
            // https://stackoverflow.com/questions/28447732/checking-if-a-double-value-is-an-integer-swift
            if newValue.truncatingRemainder(dividingBy: 1) == 0 {
                display.stringValue = String(Int(newValue))
            } else {
                display.stringValue = String(newValue)
            }
        }
    }
    
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: NSButton) {
        
        if userInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        
        let mathmaticalSymbol = sender.title
        brain.performOperation(mathmaticalSymbol)
        if brain.result != nil {
            displayValue = brain.result!
        }

    }
    
    
    @IBAction func clearAll(_ sender: NSButton) {
        brain.reset()
        displayValue = 0
    }
    
    
    @IBAction func floatingPoint(_ sender: NSButton) {
        if !userInTheMiddleOfTyping {
            display.stringValue = "0."
        } else if display.stringValue.range(of: ".") == nil {
            display.stringValue += "."
        }
        userInTheMiddleOfTyping = true
    }

}

