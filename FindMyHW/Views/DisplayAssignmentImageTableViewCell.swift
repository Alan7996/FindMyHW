//
//  DisplayAssignmentImageTableViewCell.swift
//  FindMyHW
//
//  Created by 수현 on 8/12/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

protocol DisplayAssignmentImageCellDelegate: class {
    func displayAssignmentImageTableViewCellButtonPressed(displayAssignmentImageTableViewCell: DisplayAssignmentImageTableViewCell)
}

class DisplayAssignmentImageTableViewCell: UITableViewCell {

    @IBOutlet weak var assignmentImageView: UIImageView!
    @IBOutlet weak var removeImageButton: UIButton!
    
    weak var delegate: DisplayAssignmentImageCellDelegate?
    
    var imageFile: PFFile?
    
    var date = NSDate()
    var course: Course?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let imageFile = imageFile {
            imageFile.cancel()
        }
    }
    
    var assignment: Assignment! {
        didSet {
            if let assignment = assignment {
                let assignmentDueDate = assignment["dueDate"] as! NSDate
                if assignmentDueDate.laterDate(self.date).isEqualToDate(assignmentDueDate) {
                    if course!.teacher == PFUser.currentUser() || assignment["user"].objectId == PFUser.currentUser()?.objectId{
                        removeImageButton.enabled = true
                    }
                } else {
                    removeImageButton.enabled = false
                }
            } else {
                removeImageButton.enabled = true
            }

        }
    }
    
    @IBAction func removeImageBtnClicked(sender: AnyObject) {
        delegate?.displayAssignmentImageTableViewCellButtonPressed(self)
    }
    
}
