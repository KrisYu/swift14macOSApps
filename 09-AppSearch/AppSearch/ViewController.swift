//
//  ViewController.swift
//  AppSearch
//
//  Created by Xue Yu on 7/3/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var numberResultsComboBox: NSComboBox!
    @IBOutlet weak var searchTextField: NSTextField!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet var searchResultsController: NSArrayController!
    
    dynamic var loading = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

            
        let itemPrototype = self.storyboard?.instantiateController(withIdentifier: "collectionViewItem") as! NSCollectionViewItem
        collectionView.itemPrototype = itemPrototype
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func searchClicked(_ sender: NSButton) {
        
        loading = true
        if searchTextField.stringValue == "" {
            return
        }
        
        guard let resultsNumber = Int(numberResultsComboBox.stringValue) else {
            return
        }
        
        iTunesRequestManager.getSearchResults(searchTextField.stringValue, results: resultsNumber, langString: "en_us") { (results, error) in
            
            let itunesResults = results.map{ return Result.init(dictionary: $0) }
                .enumerated().map({ (index, element) -> Result in
                element.rank  = index + 1
                return element
            })
            
            DispatchQueue.main.async {
                self.loading = false
                self.searchResultsController.content = itunesResults
                print(self.searchResultsController.content ?? "")
            }
            
        }
    }
    
    

}

// make search responses to return key
extension ViewController: NSTextFieldDelegate {
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)){
            searchClicked(NSButton.init())
        }
        return false
    }
}


extension ViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let result = searchResultsController.selectedObjects.first as? Result else {
            return
        }
        result.loadIcon()
        result.loadScreenShots()
    }
}
