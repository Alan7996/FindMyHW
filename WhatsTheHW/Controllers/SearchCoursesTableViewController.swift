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
    var refreshControl1: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        refreshControl1 = UIRefreshControl()
        refreshControl1.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl1.addTarget(self, action: #selector(SearchCoursesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func refresh() {
        coursesArray = []
        
        let notEnrolledCoursesQuery = PFQuery(className: "Course")
        
        notEnrolledCoursesQuery.includeKey("teacher")
        
        notEnrolledCoursesQuery.findObjectsInBackgroundWithBlock {
            (courses: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                for course in courses! {
                    if course["school"].objectId == PFUser.currentUser()?["school"].objectId {
                        if course["studentRelation"].containsObject((PFUser.currentUser()?.username)!) || course["teacher"].objectId == PFUser.currentUser()?.objectId {
                        } else {
                            self.coursesArray.append(course as! Course)
                        }
                    }
                }
            }
            
            self.coursesArray.sortInPlace({ $0.name!.compare($1.name!) == NSComparisonResult.OrderedAscending})
            
            self.tableView.reloadData()
            print("Refreshed")
        }
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        refresh()
        refreshControl1.endRefreshing()
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
        
        cell.courseTeacherLabel.text = course.teacher!["username"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let course = coursesArray[indexPath.row]
        course.studentRelation!.append("xx")
        // DOESN'T WORK ARGHHH
        ParseHelper.saveObjectInBackgroundWithBlock(course)
        refresh()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                            forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.1))
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
    
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCourses = coursesArray.filter { course in
            let teacherName = course.teacher!["username"] as! String
            return course.name!.lowercaseString.containsString(searchText.lowercaseString) || teacherName.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
}
extension SearchCoursesTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}