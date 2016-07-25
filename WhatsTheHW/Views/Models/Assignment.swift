//
//  Assignment.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/14/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import RealmSwift

class Assignment: Object {
    dynamic var title = ""
    dynamic var instruction = ""
    dynamic var modificationTime = NSDate()
    dynamic var dueDate = ""
    dynamic var assignmentClass = ""
}