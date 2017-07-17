//
//  CalcProgressBar.swift
//  YearProgress
//
//  Created by Xue Yu on 6/25/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Foundation

struct CalcProgressBar {
    
    static func progressBar() -> String {
        
        let current = Date()
        let cal = Calendar.current
        let dayInYear = cal.ordinality(of: .day, in: .year, for: current)!
        
        // cal days in a year
        let interval = cal.dateInterval(of: .year, for: current)!
        let numberOfDays = cal.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        let progress = Int(floor(Double((dayInYear * 100) / numberOfDays )))
        
        var yearBar = ""
        
        var i = 5
        
        while i <= 100 {
            if i <= progress {
                yearBar += "▓"
            } else {
                yearBar += "░"
            }
            i += 5
        }
        
        yearBar += " \(progress)%"
        
        return yearBar
    }
}
