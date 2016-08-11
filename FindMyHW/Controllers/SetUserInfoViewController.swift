//
//  SetUserInfoViewController.swift
//  FindMyHW
//
//  Created by 수현 on 8/7/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import UIKit
import Parse

class SetUserInfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var titlePickerView: UIPickerView!
    
    let titleArray = ["Mr. ", "Ms. ", "Mrs. ", "Dr. "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        
        titleTextField.delegate = self
        titlePickerView.delegate = self
        
        titlePickerView.hidden = true
        titleTextField.text = "Select Title"
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return titleArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return titleArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        titleTextField.text = titleArray[row]
        titlePickerView.hidden = true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        titlePickerView.hidden = false
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "UpdateInfo" {
                print("Save button tapped")
                
                if let currentUser = PFUser.currentUser() {
                    currentUser["firstName"] = firstNameTextField.text
                    currentUser["lastName"] = lastNameTextField.text
                    currentUser["title"] = titleTextField.text
                    currentUser["isTeacher"] = 1
                    
                    ParseHelper.saveObjectInBackgroundWithBlock(currentUser)
                }
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "UpdateInfo" {
            if firstNameTextField.text == "" {
                let alertController = UIAlertController(title: "No First Name", message: "Please Enter Your First Name", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
                
                return false
            } else if lastNameTextField.text == "" {
                let alertController = UIAlertController(title: "No Last Name", message: "Please Enter Your Last Name", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
                
                return false
            } else if titleTextField.text == "Select Title" {
                let alertController = UIAlertController(title: "No Title Selected", message: "Please Select Your Title", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
                
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
