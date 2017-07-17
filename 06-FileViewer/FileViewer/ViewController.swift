//
//  ViewController.swift
//  FileViewer
//
//  Created by Xue Yu on 6/27/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var statusLabel: NSTextField!
    
    let sizeFormatter = ByteCountFormatter()
    var directory: Directory?
    var directoryItems: [Metadata]?
    var sortOrder = Directory.FileOrder.Name
    var sortAscending = true

    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.stringValue = ""
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        
        
        let descriptorName = NSSortDescriptor.init(key: Directory.FileOrder.Name.rawValue, ascending: true)
        let descriptorDate = NSSortDescriptor.init(key: Directory.FileOrder.Date.rawValue, ascending: true)
        let descriptorSize = NSSortDescriptor.init(key: Directory.FileOrder.Size.rawValue, ascending: true)
        
        tableView.tableColumns[0].sortDescriptorPrototype = descriptorName
        tableView.tableColumns[1].sortDescriptorPrototype = descriptorDate
        tableView.tableColumns[2].sortDescriptorPrototype = descriptorSize


    }

    override var representedObject: Any? {
        didSet {
            if let url = representedObject as? URL {
                print("Represented object: \(url)")
                
                directory = Directory.init(folderURL: url)
                reloadFileList()
            }
        }
    }
    
    func reloadFileList() {
        directoryItems = directory?.contents(orderBy: sortOrder, ascending: sortAscending)
        tableView.reloadData()
    }
    
    func updateStatus() {
        let text: String
        
        let itemSelected = tableView.selectedRowIndexes.count
        
        if directoryItems == nil {
            text = "No Items"
        }
        else if(itemSelected == 0) {
            text = "\(directoryItems!.count) items"
        } else {
            text = "\(itemSelected) of \(directoryItems!.count) selected"
        }
        
        statusLabel.stringValue = text
    }
    
    func tableViewDoubleClick(_ sender: AnyObject) {
        
        guard tableView.selectedRow >= 0,
            let item = directoryItems?[tableView.selectedRow] else {
            return
        }
        
        if item.isFolder {
            self.representedObject = item.url as Any
        }
        else {
            NSWorkspace.shared().open(item.url as URL)
            
        }
    }


}


extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return directoryItems?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        if let order = Directory.FileOrder(rawValue: sortDescriptor.key!) {
            sortOrder = order
            sortAscending = sortDescriptor.ascending
            reloadFileList()
        }
        
    }
}


extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let DateCell = "DateCellID"
        static let SizeCell = "SizeCellID"
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        guard let item = directoryItems?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            image = item.icon
            text = item.name
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = dateFormatter.string(from: item.date)
            cellIdentifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.isFolder ? "--" : sizeFormatter.string(fromByteCount: item.size)            
            cellIdentifier = CellIdentifiers.SizeCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateStatus()
    }
}
