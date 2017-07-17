//
//  LogFile.swift
//  Pomodoro
//
//  Created by Xue Yu on 7/13/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Foundation

class LogFile {
     
    static var filePath: String? {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,
                                                            .userDomainMask,
                                                            true)
            
            let supportDirectory = paths.first! + "/Pomodoro/"
            
            do {
                try FileManager.default.createDirectory(atPath: supportDirectory,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
                let filePath = supportDirectory + "/storage.plist"
                return filePath
            } catch  {
                debugPrint(error.localizedDescription)
                return nil
            }
        }
    }
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    
    
    static func readFromLog(date: Date) -> Int {
        
        let fileManager = FileManager.default
        let dateStr =  dateFormatter.string(from: date)

        guard let logPath = LogFile.filePath else { return 0 }
        if fileManager.fileExists(atPath: logPath) {
            guard let logDict = NSDictionary(contentsOfFile: logPath) as? [String: Int] else { return 0 }
            if logDict[dateStr] != nil {
                return logDict[dateStr]!
            }
        } else {
            let logDict = [dateStr: 0]
            let plistContent = NSDictionary(dictionary: logDict)
            plistContent.write(toFile: logPath, atomically: true)
        }
        return 0
    }
    
    static func writeToLog(date: Date, finish: Int) {

        let dateStr = dateFormatter.string(from: date)
        guard let logPath = LogFile.filePath else { return }
        guard var logDict = NSDictionary(contentsOfFile: logPath) as? [String: Int] else { return }
        logDict[dateStr] = finish
        let plistContent = NSDictionary(dictionary: logDict)
        plistContent.write(toFile: logPath, atomically: true)
    }
}

