//
//  ListAssignmentsTableViewCell.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/14/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class ListAssignmentsTableViewCell: UITableViewCell {
    @IBOutlet weak var assignmentNameLabel: UILabel!
    @IBOutlet weak var assignmentInstructionLabel: UILabel!
    @IBOutlet weak var assignmentModificationTimeLabel: UILabel!
    @IBOutlet weak var assignmentDueDateLabel: UILabel!
    
    var assignment: Assignment! {
        didSet {
            assignmentNameLabel.text = assignment.title
            
            assignmentInstructionLabel.text = assignment.instruction
            
            assignmentInstructionLabel.numberOfLines = 0
            
            assignmentInstructionLabel.frame = CGRectMake(20, 20, 200, 800)
            
            assignmentInstructionLabel.sizeToFit()
            
            assignmentModificationTimeLabel.text = DateHelper.stringFromDate(assignment.updatedAt!)
            
            assignmentDueDateLabel.text = DateHelper.stringFromDate(assignment.dueDate!)
        }
    }
}
