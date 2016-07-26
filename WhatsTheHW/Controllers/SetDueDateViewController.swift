//
//  SetDueDateViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/21/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class SetDueDateViewController: UIViewController {
    
    var dueDate: String?
    var assignmentObject: Assignment?
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func datePickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/yy, HH:mm a"
        dueDate = dateFormatter.stringFromDate(myDatePicker.date)
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        print(dueDate!)
//        dueDate2 = dueDate
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboard){
        
    }

    @IBAction func clickDoneAction(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.popViewControllerAnimated(true)
        //        displayAssignmentViewController.assignmentDueDateInput = self.dueDate
        //        displayAssignmentViewController.assignmentDueDate.text = self.dueDate
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "unwindDone" {
                print("Done button tapped : \(dueDate)")
                
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
//                print("date from other: " + displayAssignmentViewController.assignmentDueDateInput)
//                print("self.dueDate: " + self.dueDate!)
                
                displayAssignmentViewController.assignmentDueDate.text = dueDate
//                assignmentObject?.dueDate = dueDate!
//                displayAssignmentViewController.assignment = assignmentObject
            }
        }
    }
}