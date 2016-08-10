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
    @NSManaged var school: AnyObject?

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
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func addCourse(course1: Course) {
        course = course1
        
        courseUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.courseUploadTask!)
        }
        
        saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            UIApplication.sharedApplication().endBackgroundTask(self.courseUploadTask!)
        }
    }
}