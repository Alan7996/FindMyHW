//
//  File.swift
//  WhatsTheHW
//
//  Created by 수현 on 2016. 6. 23..
//  Copyright © 2016년 MakeSchool. All rights reserved.
//

import Foundation
import RealmSwift

class Course: Object {
    dynamic var name = ""
    dynamic var teacher = ""
    dynamic var modificationTime = NSDate()
}