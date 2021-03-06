//
//  ParseHelper.swift
//  FindMyHW
//
//  Created by 수현 on 7/28/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    // User Relation
    static let ParseUserUsername = "username"
    
    // Course Relation
    static let ParseCourseClass = "Course"
    
    // Assignment Relation
    static let ParseAssignmentClass = "Assignment"
    static let ParseAssignmentUser = "user"
    static let ParseAssignmentCreatedAt = "createdAt"
    static let ParseAssignmentDueDate = "dueDate"
    
    /**
     A PFBooleanResult callback block that only handles error cases. You can pass this to completion blocks of Parse Requests
     */
    static func errorHandlingCallback(success: Bool, error: NSError?) -> Void {
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
    }
    
    static func saveObjectInBackgroundWithBlock(object:PFObject) {
        object.saveInBackgroundWithBlock{(success, error) in
            if success == true {
                print("save completed")
                print("\(object) saved to parse")
            } else {
                print("save failed: \(error)")
            }
        }
    }
    
    static func deleteObjectInBackgroundWithBlock(object:PFObject) {
        object.deleteInBackgroundWithBlock{(success, error) in
            if success == true {
                print("delete completed")
                print("\(object) deleted from parse")
            } else {
                print("save failed")
            }
        }
    }

}

extension PFObject {
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
}