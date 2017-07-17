//
//  ViewController.swift
//  MacSpeak
//
//  Created by Xue Yu on 6/23/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa
import AVFoundation


class ViewController: NSViewController {
    
    let mySynth = NSSpeechSynthesizer()

    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func speak(_ sender: NSButton) {
        let text = textView.string
        mySynth.startSpeaking(text ?? "")
        
    }
    
    @IBAction func stop(_ sender: NSButton) {
        mySynth.stopSpeaking()
    }

}

