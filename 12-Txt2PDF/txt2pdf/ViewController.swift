//
//  ViewController.swift
//  txt2pdf
//
//  Created by Xue Yu on 7/10/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

struct PaperSize {
    
    static let a4 = NSSize.init(width: 592, height: 841)
    static let a6 = NSSize.init(width: 296, height: 420)
}

class ViewController: NSViewController {

    
    @IBOutlet weak var paperCtrl: NSSegmentedControl!
    
    lazy var selectTxtDialog: NSOpenPanel =  {
        let panel = NSOpenPanel()
        panel.prompt = "Select txt file"
        panel.worksWhenModal = true
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.resolvesAliases = true
        return panel
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func chooseFile(_ sender: Any) {
        guard let window = view.window else { return }
        
        selectTxtDialog.beginSheetModal(for: window) { (result) in
            if result == NSModalResponseOK {
                self.selectTxtDialog.close()
                
                if let url = self.selectTxtDialog.url {
                    let paperSize = self.paperCtrl.selectedSegment == 0 ? PaperSize.a6 : PaperSize.a4
                    Txt2Pdf.createPDF(file: url, paperSize: paperSize)
                } else {
                    // Display error
                    let alert = NSAlert()
                    alert.messageText = "The selected txt is not valid"
                    alert.runModal()
                }
            }
        }
    }
    
    
}

