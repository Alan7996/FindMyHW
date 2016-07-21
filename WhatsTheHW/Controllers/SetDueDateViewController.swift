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
    @IBOutlet weak var datePicker: UIDatePicker!
    var dueDate: String?
    
    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        dueDate = dateFormatter.stringFromDate(datePicker.date)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "setDueDate" {
                print("Done button tapped")
                
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
//                displayAssignmentViewController.assignmentDueDateInput = dueDate
            }
        }
    }
}