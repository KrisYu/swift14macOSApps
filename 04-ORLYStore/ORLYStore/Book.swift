//
//  Book.swift
//  ORLYStore
//
//  Created by XueYu on 6/25/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Foundation

struct Book {
    let title: String
    let cover: String
    let edition: String
    let url: URL
    
    var thumb: String {
        return cover + "_t"
    }
    
    static func all() -> [Book] {
        return NSArray.init(contentsOfFile: Bundle.main.path(forResource: "Books", ofType: "plist")!)!.map({ row in
            let book = row as! NSDictionary
            return Book.init(title: book["title"] as! String,
                             cover: book["cover"]as! String,
                             edition: book["edition"] as! String,
                             url: URL.init(string: book["url"] as! String)!)
        })
    }
}
