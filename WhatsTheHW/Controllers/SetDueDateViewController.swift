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
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func datePickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dueDate = dateFormatter.stringFromDate(myDatePicker.date)
        print(dueDate!)
    }

    @IBAction func clickDoneAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //        displayAssignmentViewController.assignmentDueDateInput = self.dueDate
        //        displayAssignmentViewController.assignmentDueDate.text = self.dueDate
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "doneButtonClicked" {
                print("Done button tapped : \(dueDate)")
                
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                displayAssignmentViewController.assignmentDueDateInput = self.dueDate
            }
        }
    }
}