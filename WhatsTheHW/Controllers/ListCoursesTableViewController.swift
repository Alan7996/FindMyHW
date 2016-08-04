//
//  ListCoursesTableViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

var coursesGlobal = [Course]()

class ListCoursesTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCourses = [Course]()
    
    var refreshControl1: UIRefreshControl!
    
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        navigationController?.navigationBar.barTintColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        //currently showing a different RGBA value, need to check on actual device
        
        refreshControl1 = UIRefreshControl()
        refreshControl1.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl1.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        courses = []
        
        let currentUserCoursesQuery = PFQuery(className: "Course")
        
        currentUserCoursesQuery.whereKeyExists("studentRelation")
        
        currentUserCoursesQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object["school"].objectId == PFUser.currentUser()?["school"].objectId && object["studentRelation"].containsObject((PFUser.currentUser()?.username)!) {
                    self.courses.append(object as! Course)
                }
            }
            
            self.courses.sortInPlace({ $0.name!.compare($1.name!) == NSComparisonResult.OrderedAscending})
            
            coursesGlobal = self.courses
            
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
        } else if (courses != []) {
            course = courses[indexPath.row]
        } else {
            course = coursesGlobal[indexPath.row]
            // app crashes when swiped twice with "fatal eror: Index out of range"
            // issue is still not fixed and needs to be fixed in future
        }
        
        cell.courseNameLabel.text = course.name
        
        cell.courseModificationTimeLabel.text = DateHelper.stringFromDate(course.updatedAt!)
        
        cell.courseTeacherLabel.text = course.teacher

        return cell
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "displayCourse" {
                print("Table view cell tapped")
                
                let indexPath = tableView.indexPathForSelectedRow!
                let course = courses[indexPath.row]
                let listAssignmentsTableViewController = segue.destinationViewController as! ListAssignmentsTableViewController
                listAssignmentsTableViewController.course = course
                print (course.name)
                
            } else if identifier == "addCourse" {
                print("+ button tapped")
            } else if identifier == "searchToAddCourse" {
                print("Add Course button tapped")
                let searchCoursesTableViewController = segue.destinationViewController as! SearchCoursesTableViewController
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
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView : UIView?
        footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
        
        if searchController.searchBar.text == "" {
            let addCourseBtn = UIButton(type: UIButtonType.System)
//            addCourseBtn.backgroundColor = UIColor.grayColor()
            addCourseBtn.setTitle("Add Course", forState: UIControlState.Normal)
            addCourseBtn.frame = CGRectMake(0, 0, tableView.frame.size.width, 50)
            addCourseBtn.addTarget(self, action: "addCourse:", forControlEvents: UIControlEvents.TouchUpInside)
            
            footerView?.addSubview(addCourseBtn)
            
            return footerView
        } else {
            return footerView
        }
    }

    func addCourse(sender: UIButton!) {
        print("Add Course tapped")
        self.performSegueWithIdentifier("searchToAddCourse", sender: sender)
        //also need a functionality to delete the user's name from the array
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        viewWillAppear(true)
        refreshControl1.endRefreshing()
    }
    
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCourses = courses.filter { course in
            return course.name!.lowercaseString.containsString(searchText.lowercaseString)
            // need to also search teachers' names
        }
        
        tableView.reloadData()
    }
}
extension ListCoursesTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
