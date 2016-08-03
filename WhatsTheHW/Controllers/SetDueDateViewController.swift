//
//  SetDueDateViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/21/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class SetDueDateViewController: UIViewController {
    
    var dueDate: NSDate?
    var assignmentObject: Assignment?
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSDate())
        myDatePicker.minimumDate = NSDate()
    }
    
    @IBAction func datePickerAction(sender: AnyObject) {
        dueDate = myDatePicker.date
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboard){
        
    }

    @IBAction func clickDoneAction(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "unwindDone" {
                print("Done button tapped : \(dueDate)")
                
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                
                
                displayAssignmentViewController.dueDate = dueDate
                
                displayAssignmentViewController.assignmentDueDate.text = DateHelper.stringFromDate(dueDate!)
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "unwindDone" {
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
}