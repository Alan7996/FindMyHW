//
//  Assignment.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/14/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import Parse

class Assignment: PFObject, PFSubclassing {
    @NSManaged var title: String?
    @NSManaged var instruction: String?
    @NSManaged var dueDate: NSDate?
    var assignment: Assignment?
    var assignmentUploadTask: UIBackgroundTaskIdentifier?
    
    static func parseClassName() -> String {
        return "Assignment"
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
    
    func addAssignment(assignment1: Assignment) {
        assignment = assignment1
        
        assignmentUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.assignmentUploadTask!)
        }
        
        saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            UIApplication.sharedApplication().endBackgroundTask(self.assignmentUploadTask!)
        }
    }
}