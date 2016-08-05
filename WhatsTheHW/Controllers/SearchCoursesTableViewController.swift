//
//  SearchCoursesTableViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/2/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class SearchCoursesTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCourses = [Course]()
    var coursesArray: [Course] = []
    var selectedCourse: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        coursesArray = []
        
        let notEnrolledCoursesQuery = PFQuery(className: "Course")
        
        notEnrolledCoursesQuery.findObjectsInBackgroundWithBlock {
            (courses: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                for course in courses! {
                    if course["school"].objectId == PFUser.currentUser()?["school"].objectId {
                        if course["studentRelation"].containsObject((PFUser.currentUser()?.username)!){
                        } else {
                            self.coursesArray.append(course as! Course)
                        }
                    }
                }
            }
            
            self.coursesArray.sortInPlace({ $0.name!.compare($1.name!) == NSComparisonResult.OrderedAscending})
            
            self.tableView.reloadData()
        }
        print("View appeared")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredCourses.count
        }
        
        return coursesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCoursesTableViewCell", forIndexPath: indexPath) as! SearchCoursesTableViewCell
        
        let course: Course
        
        if searchController.active && searchController.searchBar.text != "" {
            course = filteredCourses[indexPath.row]
        } else {
            course = coursesArray[indexPath.row]
        }
        
        cell.courseNameLabel.text = course.name
        
        cell.courseTeacherLabel.text = course.teacher
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //adds currentuser.username to selected course's studentRelation array & refresh the table
        let courseToBeAdded = PFQuery(className: "Course")
        
        courseToBeAdded.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object.objectId == self.coursesArray[indexPath.row].objectId {
                    var array = object["studentRelation"] as! [String]
                    array.append((PFUser.currentUser()?.username)!)
                    object["studentRelation"] = array
                    ParseHelper.saveObjectInBackgroundWithBlock(object)
                }
            }
            self.viewWillAppear(true)
        }
    }
    
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCourses = coursesArray.filter { course in
            return course.name!.lowercaseString.containsString(searchText.lowercaseString) || course.teacher!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
}
extension SearchCoursesTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}