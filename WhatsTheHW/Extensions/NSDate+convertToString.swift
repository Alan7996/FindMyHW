//
//  NSDate+convertToString.swift
//  WhatsTheHW
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation

extension NSDate {
    func convertToString() -> String {
        return NSDateFormatter.localizedStringFromDate(self, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
}