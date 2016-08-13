//
//  Assignment.swift
//  FindMyHW
//
//  Created by 수현 on 7/14/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit

class Assignment: PFObject, PFSubclassing {
    @NSManaged var title: String?
    @NSManaged var instruction: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var imageFile: PFFile?
    
    var assignment: Assignment?
    var image: Observable<UIImage?> = Observable(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    var assignmentUploadTask: UIBackgroundTaskIdentifier?
    static var imageCache: NSCacheSwift<String, UIImage>!
    
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
            Assignment.imageCache = NSCacheSwift<String,UIImage>()
        }
    }
    
    func addAssignment(assignment1: Assignment) {
        assignment = assignment1
        
        if let image = image.value {
            guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            
            self.imageFile = imageFile
            
            assignmentUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.assignmentUploadTask!)
            }
            
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                }
                UIApplication.sharedApplication().endBackgroundTask(self.assignmentUploadTask!)
            }
        } else {
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
    
    func downloadImage() {
        image.value = Assignment.imageCache[self.imageFile!.name]
        // if image is not downloaded yet, get it
        if (image.value == nil) {
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                }
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    self.image.value = image
                    Assignment.imageCache[self.imageFile!.name] = image
                }
            }
        }
    }
}