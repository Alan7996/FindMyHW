//
//  ListCoursesTableViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

//My test


import UIKit
import Parse

class ListCoursesTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCourses = [Course]()
    
    var users: [User] = []
    var courses: [Course] = []
//    var coursesArray = NSMutableArray()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
//        let allCoursesQuery = PFQuery(className: "Course")
//        allCoursesQuery.whereKeyExists("name")
//        
//        allCoursesQuery.findObjectsInBackgroundWithBlock {
//            (courses: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // Do something with the found objects
//                for course in courses! {
//                    self.coursesArray.addObject(course)
//                }
//            }
//        }
        
        let currentUserCoursesQuery = PFQuery(className: "Course")
        
        currentUserCoursesQuery.whereKeyExists("studentRelation")
        
        currentUserCoursesQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object["studentRelation"].containsObject((PFUser.currentUser()?.username)!) {
                    self.courses.append(object as! Course)
                }
            }
            
            print(self.courses)
            
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredCourses.count
        }
        
        return courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCoursesTableViewCell", forIndexPath: indexPath) as! ListCoursesTableViewCell
        
        let course: Course
        
        if searchController.active && searchController.searchBar.text != "" {
            course = filteredCourses[indexPath.row]
        } else {
            course = courses[indexPath.row]
        }
        
        cell.courseNameLabel.text = course.name
        
//        cell.courseModificationTimeLabel.text = course.modificationTime.convertToString()
        
        cell.courseTeacherLabel.text = course.teacher

        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "displayCourse" {
                print("Table view cell tapped")
                
                let indexPath = tableView.indexPathForSelectedRow!
                let course = courses[indexPath.row]
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
                listAssignmentsTableViewController.course = course
                print (course.name)
                listAssignmentsTableViewController.assignments = RealmHelper.retrieveAssignments()
                
            } else if identifier == "addCourse" {
                print("+ button tapped")
            }
        }
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
//            RealmHelper.deleteCourse(courses[indexPath.row])
//            courses = RealmHelper.retrieveCourses()
        }
    }
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCourses = courses.filter { course in
            return course.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
}
extension ListCoursesTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
