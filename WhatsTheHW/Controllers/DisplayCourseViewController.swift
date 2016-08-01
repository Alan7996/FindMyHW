//
//  DisplayCourseViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift
import Parse

class DisplayCourseViewController: UIViewController {
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var courseTeacherLabel: UILabel!
    
    var course: Course?
    let username = PFUser.currentUser()?.username
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listCoursesTableViewController = segue.destinationViewController as! ListCoursesTableViewController
        if segue.identifier == "Save" {
            // if course exists, update name and teacher
            print("save clicked")
            if let course = course {
                let newCourse = Course()
                newCourse.name = courseNameTextField.text ?? ""
                newCourse.teacher = username
                
                
//                RealmHelper.updateCourse(course, newCourse: newCourse)
            } else {
                // if course does not exist, create new course
                let course = Course()
                course.name = courseNameTextField.text ?? ""
                course.teacher = username
//                course.modificationTime = NSDate()
                
                print("courseNameText: " +  courseNameTextField.text!)
                print("courseName: " + course.name!)
                
                course.addCourse(course.name!, teacherName: course.teacher!)
            }
            listCoursesTableViewController.tableView.reloadData()
            print("Data reloaded")
//            listCoursesTableViewController.courses = RealmHelper.retrieveCourses()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let course = course {
            courseNameTextField.text = course.name
            courseTeacherLabel.text = course.teacher
        } else {
            courseNameTextField.text = ""
            courseTeacherLabel.text = username
        }
    }
    
}
