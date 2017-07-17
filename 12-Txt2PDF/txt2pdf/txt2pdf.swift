//
//  txt2pdf.swift
//  txt2pdf
//
//  Created by Xue Yu on 7/10/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

// Use it cautiously, a lot of things may go wrong.
// thx to https://stackoverflow.com/questions/39135233/create-a-paginated-pdf-mac-os-x
// thx to https://stackoverflow.com/questions/2032159/uiwebview-and-local-css-file

import Foundation
import WebKit




class Txt2Pdf  {
    
    init() { }
    
    static let htmlHeader = "<html> \n <head> \n <link href=\"font.css\" rel=\"stylesheet\" type=\"text/css\" /> \n </head> \n <body> \n"
    static let htmlFooter = "</body> \n </html>"
    static let webView = WebView()
    
    

    
    static func createPDF(file: URL, paperSize: NSSize) {
        
        // Read String from the given file
        var fileContent: String
        
        do {
            try fileContent = String.init(contentsOf: file)
        } catch {
            fileContent = "Error while getting the content of file"
        }
        
        let content = String.init(format: "%@%@&@", htmlHeader, fileContent, htmlFooter)
        let cssURL = Bundle.main.url(forResource: "font", withExtension: "css")
        
        // Create css file to modify font

        createPDF(content: content, cssURL: cssURL, paperSize: paperSize)
        
    }
    
    

    
    // by default, create normal with a4 paper
    static func createPDF(content: String, cssURL: URL?, paperSize: NSSize)  {
        

        webView.mainFrame.loadHTMLString(content, baseURL: cssURL)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { 
            let printOpts = [ NSPrintJobDisposition: NSPrintSaveJob as AnyObject]
            let printInfo = NSPrintInfo.init(dictionary: printOpts)

            printInfo.paperSize = paperSize
            printInfo.topMargin = 10.0
            printInfo.leftMargin = 10.0
            printInfo.rightMargin = 10.0
            printInfo.bottomMargin = 10.0
            
            let printOp = NSPrintOperation.init(view: self.webView.mainFrame.frameView.documentView, printInfo: printInfo)
            printOp.showsPrintPanel = false
            printOp.showsProgressPanel = false
            printOp.run()
        }
    }

}
