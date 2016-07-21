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
    @IBOutlet weak var assignmentInstructionTextField: UITextField!
    @IBOutlet weak var assignmentModificationTimeLabel: UILabel!
    
    var assignment: Assignment?
    var course: Course?
    
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
                newAssignment.instruction = assignmentInstructionTextField.text ?? ""
                
                RealmHelper.updateAssignment(assignment, newAssignment: newAssignment)
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
                listAssignmentsTableViewController.assignments = RealmHelper.retrieveAssignments()
            } else {
                // if note does not exist, create new note
                let assignment = Assignment()
                assignment.title = assignmentTitleTextField.text ?? ""
                assignment.instruction = assignmentInstructionTextField.text ?? ""
                assignment.modificationTime = NSDate()
                assignment.assignmentClass = course!.name
                
                print("assignmentNameText: " +  assignmentTitleTextField.text!)
                print("assignmentName: " + assignment.title)
                
                RealmHelper.addAssignment(assignment)
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
                listAssignmentsTableViewController.assignments = RealmHelper.retrieveAssignments()
                
                print("\(listAssignmentsTableViewController.assignments.count) assignments in listAssignmentsTableViewController")
            }

        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let assignment = assignment {
            assignmentTitleTextField.text = assignment.title
            assignmentInstructionTextField.text = assignment.instruction
        } else {
            assignmentTitleTextField.text = ""
            assignmentInstructionTextField.text = ""
        }
    }
    
}
