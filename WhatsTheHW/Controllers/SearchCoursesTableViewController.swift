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
        
        let allCoursesQuery = PFQuery(className: "Course")
        allCoursesQuery.whereKeyExists("name")
        
        allCoursesQuery.findObjectsInBackgroundWithBlock {
            (courses: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                for course in courses! {
                    if course["studentRelation"].containsObject((PFUser.currentUser()?.username)!) {
                    } else {
                        self.coursesArray.append(course as! Course)
                    }
                }
            }
            
            self.coursesArray.sortInPlace({ $0.name!.compare($1.name!) == NSComparisonResult.OrderedAscending})
            
            self.tableView.reloadData()
        }
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
    }
    
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCourses = coursesArray.filter { course in
            return course.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
}
extension SearchCoursesTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}