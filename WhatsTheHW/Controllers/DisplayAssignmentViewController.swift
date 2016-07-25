//
//  DisplayAssignmentViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class DisplayAssignmentViewController: UIViewController {
    @IBOutlet weak var assignmentTitleTextField: UITextField!
    @IBOutlet weak var assignmentInstructionTextView: UITextView!
    @IBOutlet weak var assignmentModificationTimeLabel: UILabel!
    @IBOutlet weak var assignmentDueDate: UILabel!
    
    var assignment: Assignment?
    var course: Course?
    var assignmentDueDateInput: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (course?.name)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "Save" {
            // if assignment exists, update title and content
            print("save clicked")
            if let assignment = assignment {
                let newAssignment = Assignment()
                newAssignment.title = assignmentTitleTextField.text ?? ""
                newAssignment.instruction = assignmentInstructionTextView.text ?? ""
                if let assignmentDueDateInput = assignmentDueDateInput {
                        newAssignment.dueDate = assignmentDueDateInput
                }
                
                RealmHelper.updateAssignment(assignment, newAssignment: newAssignment)
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
                listAssignmentsTableViewController.assignments = RealmHelper.retrieveAssignments()
            } else {
                // if note does not exist, create new note
                let assignment = Assignment()
                assignment.title = assignmentTitleTextField.text ?? ""
                assignment.instruction = assignmentInstructionTextView.text ?? ""
                assignment.modificationTime = NSDate()
                assignment.assignmentClass = course!.name
                if let assignmentDueDateInput = assignmentDueDateInput {
                    assignment.dueDate = assignmentDueDateInput
                }
                
                print("assignmentNameText: " +  assignmentTitleTextField.text!)
                print("assignmentName: " + assignment.title)
                
                RealmHelper.addAssignment(assignment)
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
                listAssignmentsTableViewController.assignments = RealmHelper.retrieveAssignments()
                
                print("\(listAssignmentsTableViewController.assignments.count) assignments in listAssignmentsTableViewController")
            }
//        } else if segue.identifier == "setDueDate" {
//            let setDueDateViewController = segue.destinationViewController as! SetDueDateViewController
//            setDueDateViewController.displayAssignmentViewController = self
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let assignment = assignment {
            assignmentTitleTextField.text = assignment.title
            assignmentInstructionTextView.text = assignment.instruction
        } else {
            assignmentTitleTextField.text = ""
            assignmentInstructionTextView.text = ""
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear : \(assignmentDueDateInput)")
        if let assignmentDueDateInput = assignmentDueDateInput {
            assignmentDueDate.text = assignmentDueDateInput
        }
    }
    
}
