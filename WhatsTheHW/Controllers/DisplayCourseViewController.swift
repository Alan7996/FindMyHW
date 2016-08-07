//
//  DisplayCourseViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class DisplayCourseViewController: UIViewController {
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var courseTeacherLabel: UILabel!
    
    var course: Course?
    let username = PFUser.currentUser()?.username
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let course = course {
            courseNameTextField.text = course.name
            courseTeacherLabel.text = course.teacher!["username"] as! String
        } else {
            courseNameTextField.text = ""
            courseTeacherLabel.text = username
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listCoursesTableViewController = segue.destinationViewController as! ListCoursesTableViewController
        if segue.identifier == "Save" {
            // if course exists, update name
            print("save clicked")
            if let course = course {
                course.name = courseNameTextField.text ?? ""
                
                course.saveInBackground()
                //hasn't been check if works yet, original:
                //let newCourse = Course()
                //newCourse.name = courseNameTextField.text ?? ""
                //newCourse.teacher = username
            } else {
                // if course does not exist, create new course
                let newCourse = Course()
                newCourse.name = courseNameTextField.text ?? ""
                newCourse.teacher = PFUser.currentUser()
                newCourse.school = PFUser.currentUser()!["school"]
                newCourse.studentRelation = []
                
                print("courseNameText: " +  courseNameTextField.text!)
                print("courseName: " + newCourse.name!)
                
                newCourse.addCourse(newCourse)
            }
            listCoursesTableViewController.tableView.reloadData()
            print("Data reloaded")
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "Save" {
            if courseNameTextField.text == "" {
                let alertController = UIAlertController(title: "No Course Name", message: "Please Set The Name of the Course", preferredStyle: UIAlertControllerStyle.Alert)
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
