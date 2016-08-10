//
//  DateHelper.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/2/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation

class DateHelper {
    
    static func stringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/yy, HH:mm a"
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
}