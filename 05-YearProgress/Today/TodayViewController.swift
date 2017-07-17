//
//  TodayViewController.swift
//  Today
//
//  Created by Xue Yu on 6/25/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    
    
    @IBOutlet weak var label: NSTextFieldCell!
    
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        label.stringValue = CalcProgressBar.progressBar()
        completionHandler(.noData)
    }

}
