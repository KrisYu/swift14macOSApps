//
//  ViewController.swift
//  YearProgress
//
//  Created by Xue Yu on 6/25/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var yearProgress: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    override func viewWillAppear() {
            
        yearProgress.stringValue = CalcProgressBar.progressBar()
        
    }
}

