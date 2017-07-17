//
//  ViewController.swift
//  ORLYStore
//
//  Created by XueYu on 6/25/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    @IBOutlet weak var coverImageView: NSImageView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var editionTextField: NSTextField!
    @IBOutlet weak var topStack: NSStackView!
    
    let books = Book.all()
    
    @IBAction func actionToggleListView(_ sender: AnyObject){
        
        if let button = sender as? NSToolbarItem {
            switch button.tag {
            case 0:
                button.tag = 1
                button.image = NSImage.init(named: "list-selected-icon")
            case 1:
                button.tag = 0
                button.image = NSImage.init(named: "list-icon")
            default:
                break
            }
            
            // toggle side bar visibility
            
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.25
                context.allowsImplicitAnimation = true
                
                self.topStack.arrangedSubviews.first?.isHidden = button.tag == 0 ? true: false
                self.view.layoutSubtreeIfNeeded()
            }, completionHandler: nil)
        }
        
        
    }
    

    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let window = view.window {
            
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
        }
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.init(calibratedWhite: 0.98, alpha: 1).cgColor
        
        tableView.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: false)
        displayBookDetail(books[tableView.selectedRow])
    }
    
    func displayBookDetail(_ book: Book){
        coverImageView.image = NSImage.init(named: book.cover)
        editionTextField.stringValue = book.edition
        titleTextField.stringValue = book.title
    }
    
    
    @IBAction func actionBuySelectedBook(_ sender: NSButton) {
        let book = books[tableView.selectedRow]
        NSWorkspace.shared().open(book.url)
    }

}


//
//  Table View Code
//

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: "BookCell", owner: self) as! BookCellView
        let book = books[row]
        
        cell.coverImage.image = NSImage.init(named: book.thumb)
        cell.bookTitle.stringValue = book.title
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        displayBookDetail(books[row])
        return true
    }
}
