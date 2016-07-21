//
//  DisplayCourseViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class DisplayCourseViewController: UIViewController {
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var courseTeacherTextField: UITextField!
    
    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listCoursesTableViewController = segue.destinationViewController as! ListCoursesTableViewController
        if segue.identifier == "Save" {
            // if note exists, update title and content
            print("save clicked")
            if let course = course {
                let newCourse = Course()
                newCourse.name = courseNameTextField.text ?? ""
                newCourse.teacher = courseTeacherTextField.text ?? ""
                
                
                RealmHelper.updateCourse(course, newCourse: newCourse)
            } else {
                // if note does not exist, create new note
                let course = Course()
                course.name = courseNameTextField.text ?? ""
                course.teacher = courseTeacherTextField.text ?? ""
                course.modificationTime = NSDate()
                
                print("courseNameText: " +  courseNameTextField.text!)
                print("courseName: " + course.name)
                
                RealmHelper.addCourse(course)
            }
            listCoursesTableViewController.courses = RealmHelper.retrieveCourses()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let course = course {
            courseNameTextField.text = course.name
            courseTeacherTextField.text = course.teacher
        } else {
            courseNameTextField.text = ""
            courseTeacherTextField.text = ""
        }
    }
    
}
