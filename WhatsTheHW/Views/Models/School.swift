//
//  School.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/4/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import Parse

class School: PFObject, PFSubclassing {
    @NSManaged var schoolName: String?
    @NSManaged var cityName: String?
    @NSManaged var country: String?
    var school: School?
    var schoolUploadTask: UIBackgroundTaskIdentifier?
    
    static func parseClassName() -> String {
        return "School"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
}