//
//  Photo.swift
//  FindMyHW
//
//  Created by 수현 on 8/12/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit

class Photo: PFObject, PFSubclassing {
    @NSManaged var imageFile: PFFile?
    
    var photo: Photo?
    var image: Observable<UIImage?> = Observable(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    static var imageCache: NSCacheSwift<String, UIImage>!
    
    static func parseClassName() -> String {
        return "Photo"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
            Photo.imageCache = NSCacheSwift<String,UIImage>()
        }
    }
    
    func addPhoto(photo1: Photo) {
        photo = photo1
        
        if let image = image.value {
            guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            
            self.imageFile = imageFile
        
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                }
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
}