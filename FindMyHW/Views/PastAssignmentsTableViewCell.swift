//
//  PastAssignmentsTableViewCell.swift
//  FindMyHW
//
//  Created by 수현 on 8/11/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class PastAssignmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var assignmentNamLabel: UILabel!
    @IBOutlet weak var assignmentInstructionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var assignment: Assignment! {
        didSet {
            assignmentNamLabel.text = assignment.title
            
            assignmentInstructionLabel.text = assignment.instruction
            
            assignmentInstructionLabel.numberOfLines = 0
            
            assignmentInstructionLabel.frame = CGRectMake(20, 20, 200, 800)
            
            assignmentInstructionLabel.sizeToFit()
            
            dueDateLabel.text = DateHelper.stringFromDate(assignment.updatedAt!)
            
            dueDateLabel.text = DateHelper.stringFromDate(assignment.dueDate!)
        }
    }

}
