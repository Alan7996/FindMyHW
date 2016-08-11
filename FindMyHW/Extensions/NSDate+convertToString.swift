//
//  NSDate+convertToString.swift
//  FindMyHW
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import Foundation

extension NSDate {
    func convertToString() -> String {
        return NSDateFormatter.localizedStringFromDate(self, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
}