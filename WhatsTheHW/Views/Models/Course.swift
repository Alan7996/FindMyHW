//
//  File.swift
//  WhatsTheHW
//
//  Created by 수현 on 2016. 6. 23..
//  Copyright © 2016년 MakeSchool. All rights reserved.
//

import Foundation
import Parse

class Course: PFObject, PFSubclassing {
    @NSManaged var name: String?
    @NSManaged var teacher: PFUser?
    var course: Course?
    var courseUploadTask: UIBackgroundTaskIdentifier?
    
    static func parseClassName() -> String {
        return "Course"
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
    
    func addCourse() {
        if let course = course {
            teacher = PFUser.currentUser()
            
            courseUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.courseUploadTask!)
            }
            
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                UIApplication.sharedApplication().endBackgroundTask(self.courseUploadTask!)
            }
        }
    }
}