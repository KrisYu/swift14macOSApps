//
//  ViewController.swift
//  SlideMagic
//
//  Created by Xue Yu on 7/12/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var collectionView: NSCollectionView!

    let imageDirectoryLoader = ImageDirectoryLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()

        let initialFolderUrl = URL(fileURLWithPath: "/Library/Desktop Pictures", isDirectory: true)
        imageDirectoryLoader.loadDataForFolderWithUrl(initialFolderUrl)
    }
    
    
    func loadDataForNewFolderWithUrl(_ folderURL: URL)  {
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL)
        collectionView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    fileprivate func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160, height: 140)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        
        collectionView.collectionViewLayout = flowLayout
        
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.white.cgColor
    }


}

extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDirectoryLoader.numberOfItems()
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
        guard let collectionView = item as? CollectionViewItem else { return item}
        
        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
        collectionView.imageFile = imageFile
        return item
        
    }
    
}

