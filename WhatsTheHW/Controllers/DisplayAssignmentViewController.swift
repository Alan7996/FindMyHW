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
    var dueDate: NSDate?
    var objectID: String?
    var parseAssignment: Assignment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assignmentInstructionTextView.layer.borderWidth = 0.5
        self.assignmentInstructionTextView.layer.borderColor = (UIColor( red: 0.5, green: 0.5, blue:0.5, alpha: 0.5 )).CGColor
        self.assignmentInstructionTextView.layer.cornerRadius = 10
        
        if let assignment = assignment {
            assignmentTitleTextField.text = assignment.title
            assignmentInstructionTextView.text = assignment.instruction
            assignmentDueDate.text = DateHelper.stringFromDate(assignment.dueDate!)
        } else {
            assignmentTitleTextField.text = ""
            assignmentInstructionTextView.text = ""
            assignmentDueDate.text = ""
        }
        
        let currentCourseAssignmentsQuery = PFQuery(className: "Assignment")
        
        currentCourseAssignmentsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object.objectId == self.objectID {
                    self.parseAssignment = object as? Assignment
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "Save" {
            // if assignment exists, update title, instruction and due date
            print("save clicked")
            if let parseAssignment = assignment {
                
                parseAssignment.title = assignmentTitleTextField.text ?? ""
                parseAssignment.instruction = assignmentInstructionTextView.text ?? ""
                parseAssignment.dueDate = dueDate
                
                parseAssignment.saveInBackground()
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
                
//                listAssignmentsTableViewController.assignments = RealmHelper.retrieveAssignments()
                listAssignmentsTableViewController.tableView.reloadData()
            } else {
                // if assignment does not exist, create new assignment
                let newAssignment = Assignment()
                newAssignment.title = assignmentTitleTextField.text ?? ""
                newAssignment.instruction = assignmentInstructionTextView.text ?? ""
                newAssignment.dueDate = dueDate
                
                newAssignment.setObject(PFUser.currentUser()!, forKey: "user")
                newAssignment.setObject(course!, forKey: "course")
                
                newAssignment.addAssignment(newAssignment)
                
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
                
                listAssignmentsTableViewController.tableView.reloadData()
            }
        } else if segue.identifier == "setDueDate" {
            let setDueDateViewController = segue.destinationViewController as! SetDueDateViewController
            setDueDateViewController.assignmentObject = assignment
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "Save" {
            if dueDate == nil {
                let alert = UIAlertView()
                alert.title = "No Due Date"
                alert.message = "Please Set The Due Date"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            }
            else {
                return true
            }
        }
        // by default, transition
        return true
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
}
