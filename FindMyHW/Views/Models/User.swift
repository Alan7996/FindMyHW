//
//  User.swift
//  FindMyHW
//
//  Created by 수현 on 7/27/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import Parse

class User: PFObject, PFSubclassing {
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var yearGroup: String?
    @NSManaged var enrolledClasses: String?
    @NSManaged var isTeacher: NSNumber?
    @NSManaged var title: String?
    
    var user: User?
    
    static func parseClassName() -> String {
        return "User"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}