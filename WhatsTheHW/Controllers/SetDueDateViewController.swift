//
//  SetDueDateViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/21/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

var dueDate2:String!

class SetDueDateViewController: UIViewController {
    
    var dueDate: String?
    var assignmentObject: Assignment?
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func datePickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dueDate = dateFormatter.stringFromDate(myDatePicker.date)
        print(dueDate!)
        dueDate2 = dueDate
        print("dueDate2 .1: " + dueDate2)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboard){
        
    }

    @IBAction func clickDoneAction(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.popViewControllerAnimated(true)
        //        displayAssignmentViewController.assignmentDueDateInput = self.dueDate
        //        displayAssignmentViewController.assignmentDueDate.text = self.dueDate
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier {
//            if identifier == "unwindDone" {
//                print("Done button tapped : \(dueDate)")
//                
//                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
//                print("date from other: " + displayAssignmentViewController.assignmentDueDateInput)
//                print("self.dueDate: " + self.dueDate!)
//                
////                assignmentObject?.dueDate = dueDate!
////                displayAssignmentViewController.assignment = assignmentObject
//            }
//        }
//    }
}