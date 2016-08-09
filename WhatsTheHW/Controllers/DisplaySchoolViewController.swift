//
//  DisplaySchoolViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/4/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class DisplaySchoolViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    @IBOutlet weak var schoolNameTextField: UITextField!
    @IBOutlet weak var schoolCityTextField: UITextField!
    @IBOutlet weak var schoolCountryTextField: UITextField!
    @IBOutlet weak var countryPickerView: UIPickerView!
    
    var school: School?
    
    let countries = NSLocale.ISOCountryCodes().map { (code:String) -> String in
        let id = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: code])
        return NSLocale(localeIdentifier: "en_US").displayNameForKey(NSLocaleIdentifier, value: id) ?? "Country not found for code: \(code)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        schoolCountryTextField.delegate = self
        countryPickerView.delegate = self
        
        countryPickerView.hidden = true
        schoolCountryTextField.text = "Select Title"
        schoolCityTextField.text = ""
        schoolNameTextField.text = ""
        
//        self.view.backgroundColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.1))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        schoolNameTextField.text = ""
        schoolCityTextField.text = ""
        schoolCountryTextField.text = ""
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return countries.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        schoolCountryTextField.text = countries[row]
        countryPickerView.hidden = true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        countryPickerView.hidden = false
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listSchoolTableViewController = segue.destinationViewController as! ListSchoolTableViewController
        if segue.identifier == "Save" {
            print("save clicked")
            
            // create new school
            let newSchool = School()
            newSchool.schoolName = schoolNameTextField.text ?? ""
            newSchool.cityName = schoolCityTextField.text ?? ""
            newSchool.country = schoolCountryTextField.text ?? ""
            
            print("schoolNameText: " +  schoolNameTextField.text!)
            print("schoolCityText: " + newSchool.schoolName!)
            
            newSchool.addSchool(newSchool)
            
            listSchoolTableViewController.tableView.reloadData()
            print("Data reloaded")
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "Save" {
            if schoolNameTextField.text == "" {
                let alertController = UIAlertController(title: "No School Name", message: "Please Set The Name of the School", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
                
                return false
            } else if schoolCityTextField.text == "" {
                let alertController = UIAlertController(title: "No City Name", message: "Please Set The Name of the City", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
                
                return false
            } else if schoolCountryTextField.text == "" {
                let alertController = UIAlertController(title: "No Country Name", message: "Please Set The Name of the Country", preferredStyle: UIAlertControllerStyle.Alert)
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