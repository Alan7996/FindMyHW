//
//  DisplayAssignmentInfoTableViewCell.swift
//  FindMyHW
//
//  Created by 수현 on 8/12/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

protocol DisplayAssignmentInfoCellDelegate: class {
    func updateTextField(cell: DisplayAssignmentInfoTableViewCell, newString: String)
    func updateTextView(cell:DisplayAssignmentInfoTableViewCell, newString: String)
}

class DisplayAssignmentInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var assignmentTitleTextField: UITextField!
    @IBOutlet weak var assignmentInstructionTextView: UITextView!
    @IBOutlet weak var assignmentModificationTimeLabel: UILabel!
    @IBOutlet weak var assignmentDueDate: UILabel!
    @IBOutlet weak var calendarButton: UIButton!

    weak var delegate: DisplayAssignmentInfoCellDelegate?
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var date = NSDate()
    var course: Course?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        assignmentTitleTextField.delegate = self
        assignmentInstructionTextView.delegate = self
    }

    
    var assignment: Assignment! {
        didSet {
            
            if let assignment = assignment {
                let assignmentDueDate = assignment["dueDate"] as! NSDate
                if assignmentDueDate.laterDate(self.date).isEqualToDate(assignmentDueDate) {
                    if course!.teacher == PFUser.currentUser() || assignment["user"].objectId == PFUser.currentUser()?.objectId{
                        assignmentTitleTextField.userInteractionEnabled = true
                        assignmentInstructionTextView.userInteractionEnabled = true
                        calendarButton.userInteractionEnabled = true
                    }
                } else {
                    assignmentTitleTextField.userInteractionEnabled = false
                    assignmentInstructionTextView.userInteractionEnabled = false
                    calendarButton.userInteractionEnabled = false
                }
            } else {
                assignmentTitleTextField.userInteractionEnabled = true
                assignmentInstructionTextView.userInteractionEnabled = true
                calendarButton.userInteractionEnabled = true
            }
            
            assignmentInstructionTextView.layer.borderWidth = 0.5
            assignmentInstructionTextView.layer.borderColor = (UIColor( red: 0.5, green: 0.5, blue:0.5, alpha: 0.5 )).CGColor
            assignmentInstructionTextView.layer.cornerRadius = 10
        }
    }
}
extension DisplayAssignmentInfoTableViewCell: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
        let textFieldText = assignmentTitleTextField.text!
        let newString: String
        if string.characters.count == 0 {
            newString = textFieldText.substringToIndex(textFieldText.endIndex.predecessor())
        }
        else {
            newString = textFieldText + string
        }
        print("the new string is: \(newString)")
        delegate?.updateTextField(self, newString: newString)
        return true
    }
}
extension DisplayAssignmentInfoTableViewCell: UITextViewDelegate {
    
//    func textView(textView: UITextView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        print("the new string is: \(assignmentInstructionTextView.text)")
//        delegate?.updateTextView(self, newString: "\(textView.text!)\(string)")
//        return true
//    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print("the new string is: \(assignmentInstructionTextView.text)")
        delegate?.updateTextView(self, newString: "\(textView.text!)\(text)")
        return true
    }
}