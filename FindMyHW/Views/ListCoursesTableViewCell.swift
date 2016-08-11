//
//  ListCoursesTableViewCell.swift
//  FindMyHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import UIKit
import Parse

protocol ListCoursesTableViewCellDelegate: class {
    func listCoursesTableViewCellButtonPressed(listCoursesTableViewCell: ListCoursesTableViewCell)
}

class ListCoursesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseModificationTimeLabel: UILabel!
    @IBOutlet weak var courseTeacherLabel: UILabel!
    
    @IBOutlet weak var isLockedBtn: UIButton!
    
    @IBAction func isLockedButtonPressed(sender: UIButton) {
        self.delegate?.listCoursesTableViewCellButtonPressed(self)
    }
    
    weak var delegate: ListCoursesTableViewCellDelegate?
    
    var course: Course! {
        didSet {
            courseNameLabel.text = course.name
            
            courseModificationTimeLabel.text = DateHelper.stringFromDate(course.updatedAt!)
            
            let courseTeacherTitle = course.teacher!["title"] as! String
            let courseTeacherLastName = course.teacher!["lastName"] as! String
            courseTeacherLabel.text = courseTeacherTitle + courseTeacherLastName
            
            if PFUser.currentUser()?.objectId == course.teacher!.objectId {
                if course["isLocked"] as! Int == 1 {
                    let lockedImage = UIImage(named: "Locked.png")
                    isLockedBtn.setImage(lockedImage, forState: .Normal)
                } else {
                    let unlockedIkmage = UIImage(named: "Unlocked.png")
                    isLockedBtn.setImage(unlockedIkmage, forState: .Normal)
                }
            } else {
                isLockedBtn.hidden = true
            }
        }
    }
}