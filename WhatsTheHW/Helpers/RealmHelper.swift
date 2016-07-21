//
//  RealmHelper.swift
//  WhatsTheHW
//
//  Created by 수현 on 2016. 6. 23..
//  Copyright © 2016년 MakeSchool. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    //static methods will go here
    static func addCourse(course: Course) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(course)
        }
    }
    static func addAssignment(assignment: Assignment) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(assignment)
        }
    }
    static func deleteCourse(course: Course) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(course)
        }
    }
    static func deleteAssignment(assignment: Assignment) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(assignment)
        }
    }
    static func updateCourse(courseToBeUpdated: Course, newCourse: Course) {
        let realm = try! Realm()
        try! realm.write() {
            courseToBeUpdated.name = newCourse.name
            courseToBeUpdated.teacher = newCourse.teacher
            courseToBeUpdated.modificationTime = newCourse.modificationTime
        }
    }
    static func updateAssignment(assignmentToBeUpdated: Assignment, newAssignment: Assignment) {
        let realm = try! Realm()
        try! realm.write() {
            assignmentToBeUpdated.title = newAssignment.title
            assignmentToBeUpdated.instruction = newAssignment.instruction
            assignmentToBeUpdated.modificationTime = newAssignment.modificationTime
        }
    }
    static func retrieveCourses() -> Results<Course> {
        let realm = try! Realm()
        return realm.objects(Course).sorted("modificationTime", ascending: false)
    }
    static func retrieveAssignments() -> Results<Assignment> {
        let realm = try! Realm()
        return realm.objects(Assignment).sorted("modificationTime", ascending: false)
    }
}
