//
//  ListCoursesTableViewController.swift
//  FindMyHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

// Pull to refresh needs to be implemented

import UIKit
import Parse

var assignmentsGlobal = [Assignment]()

class ListAssignmentsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var refreshControl1: UIRefreshControl!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredAssignments = [Assignment]()
    
    var course: Course?
    var assignments: [Assignment] = []
    
    let date = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = course?.name
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
        
        refreshControl1 = UIRefreshControl()
        refreshControl1.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl1.addTarget(self, action: #selector(ListAssignmentsTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl1)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func refresh() {
        assignments = []
        
        let currentCourseAssignmentsQuery = PFQuery(className: "Assignment")
        
        currentCourseAssignmentsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                let objectDueDate = object["dueDate"] as! NSDate
                if object["course"].objectId == ((self.course?.objectId)!) && objectDueDate.laterDate(self.date).isEqualToDate(objectDueDate){
                    self.assignments.append(object as! Assignment)
                }
            }
            
            self.assignments.sortInPlace({ $0.dueDate!.compare($1.dueDate!) == NSComparisonResult.OrderedAscending})
            
            assignmentsGlobal = self.assignments
            
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
            return filteredAssignments.count
        }

        return assignments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listAssignmentsTableViewCell", forIndexPath: indexPath) as! ListAssignmentsTableViewCell
        
        let assignment: Assignment
        
        if searchController.active && searchController.searchBar.text != "" {
            assignment = filteredAssignments[indexPath.row]
        } else if assignments != [] {
            assignment = assignments[indexPath.row]
        } else {
            assignment = assignmentsGlobal[indexPath.row]
        }
        
        cell.assignment = assignment
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                            forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.row == 0) {
            cell.backgroundColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.2))
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0)).CGColor
        } else if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.05))
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            let assignment = assignments[indexPath.row]
            if course!.teacher == PFUser.currentUser() {
                let alert = UIAlertController(title: "Delete", message: "This assignment will be permanently deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                    print("\(assignment.title) deleted")
                    ParseHelper.deleteObjectInBackgroundWithBlock(assignment)
                    self.refresh()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                    print("\(assignment.title) delete canceled")
                }))
                presentViewController(alert, animated: true, completion: nil)
            } else if assignment["user"].objectId == PFUser.currentUser()?.objectId {
                let alert = UIAlertController(title: "Delete", message: "This assignment will be permanently deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                    print("\(assignment.title) deleted")
                    ParseHelper.deleteObjectInBackgroundWithBlock(assignment)
                    self.refresh()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                    print("\(assignment.title) delete canceled")
                }))
                presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "You have no authority to delete this post.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    print("Could not delete assignment.")
                }))
                
                presentViewController(alert, animated: true, completion: nil)
            }

        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredAssignments = assignments.filter { assignment in
            return assignment.title!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "addAssignment" {
                print("+ button tapped")
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                displayAssignmentViewController.course = course
                
            } else if identifier == "displayAssignment" {
                print("Table view cell tapped")
                let indexPath = tableView.indexPathForSelectedRow!
                let assignment = assignments[indexPath.row]
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                displayAssignmentViewController.assignment = assignment
                displayAssignmentViewController.course = course
                displayAssignmentViewController.objectID = assignment.objectId
                
            } else if identifier == "pastAssignments" {
                print ("Previous button tapped")
                let pastAssignmentsTableViewController = segue.destinationViewController as! PastAssignmentsTableViewController
                pastAssignmentsTableViewController.course = course
            }
        }
    }
    
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
}
extension ListAssignmentsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}