//
//  DisplayAssignmentViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class DisplayAssignmentViewController: UIViewController {
    @IBOutlet weak var assignmentTitleTextField: UITextField!
    @IBOutlet weak var assignmentInstructionTextView: UITextView!
    @IBOutlet weak var assignmentModificationTimeLabel: UILabel!
    @IBOutlet weak var assignmentDueDate: UILabel!
    
    var assignment: Assignment?
    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (course?.name)
        self.assignmentInstructionTextView.layer.borderWidth = 0.5
        self.assignmentInstructionTextView.layer.borderColor = (UIColor( red: 0.5, green: 0.5, blue:0.5, alpha: 0.5 )).CGColor
        self.assignmentInstructionTextView.layer.cornerRadius = 10
        if let assignment = assignment {
            assignmentTitleTextField.text = assignment.title
            assignmentInstructionTextView.text = assignment.instruction
            assignmentDueDate.text = String(assignment.dueDate)
        } else {
            assignmentTitleTextField.text = ""
            assignmentInstructionTextView.text = ""
            assignmentDueDate.text = ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "Save" {
            // if assignment exists, update title, instruction and due date
            print("save clicked")
            if let assignment = assignment {
                let newAssignment = Assignment()
                newAssignment.title = assignmentTitleTextField.text ?? ""
                newAssignment.instruction = assignmentInstructionTextView.text ?? ""
//                newAssignment.dueDate = assignmentDueDate.text ?? ""
                
//                RealmHelper.updateAssignment(assignment, newAssignment: newAssignment)
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
//                listAssignmentsTableViewController.assignments = RealmHelper.retrieveAssignments()
            } else {
                // if assignment does not exist, create new assignment
                let assignment = Assignment()
                assignment.title = assignmentTitleTextField.text ?? ""
                assignment.instruction = assignmentInstructionTextView.text ?? ""
//                assignment.modificationTime = NSDate()
//                assignment.assignmentClass = course!.name!
//                assignment.dueDate = assignmentDueDate.text ?? ""
                
                print("assignmentNameText: " +  assignmentTitleTextField.text!)
                print("assignmentName: " + assignment.title!)
//                print("asisgnmentDueDate: " + assignment.dueDate)
                
//                RealmHelper.addAssignment(assignment)
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
//                listAssignmentsTableViewController.assignments = RealmHelper.retrieveAssignments()
                
                print("\(listAssignmentsTableViewController.assignments.count) assignments in listAssignmentsTableViewController")
            }
        } else if segue.identifier == "setDueDate" {
            let setDueDateViewController = segue.destinationViewController as! SetDueDateViewController
            setDueDateViewController.assignmentObject = assignment
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
//        if let assignment = assignment {
//            assignmentDueDate.text = dueDate2 ?? "0/0/2016"
//        } else {
//            assignmentDueDate.text = ""
//        }

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
}
