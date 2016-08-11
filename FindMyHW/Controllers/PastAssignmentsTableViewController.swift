//
//  PastAssignmentsTableViewController.swift
//  FindMyHW
//
//  Created by 수현 on 8/11/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class PastAssignmentsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var refreshControl1: UIRefreshControl!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredAssignments = [Assignment]()
    
    var course: Course?
    
    var pastAssignmentsArray = [Assignment]()
    
    let date = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Past Assignments"
        
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
        pastAssignmentsArray = []
        
        let currentCoursePastAssignmentsQuery = PFQuery(className: "Assignment")

        currentCoursePastAssignmentsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                let objectDueDate = object["dueDate"] as! NSDate
                if object["course"].objectId == ((self.course?.objectId)!) && objectDueDate.earlierDate(self.date).isEqualToDate(objectDueDate) {
                    self.pastAssignmentsArray.append(object as! Assignment)
                }
            }

            self.pastAssignmentsArray.sortInPlace({ $0.dueDate!.compare($1.dueDate!) == NSComparisonResult.OrderedAscending})
            
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
        
        return pastAssignmentsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pastAssignmentsTableViewCell", forIndexPath: indexPath) as! PastAssignmentsTableViewCell
        
        let assignment: Assignment
        
        if searchController.active && searchController.searchBar.text != "" {
            assignment = filteredAssignments[indexPath.row]
        } else {
            assignment = pastAssignmentsArray[indexPath.row]
        }
        
        cell.assignment = assignment
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                            forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.05))
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let  assignment = pastAssignmentsArray[indexPath.row]
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
        filteredAssignments = pastAssignmentsArray.filter { assignment in
            return assignment.title!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "displayPastAssignment" {
                print("Table view cell tapped")
                let indexPath = tableView.indexPathForSelectedRow!
                let assignment = pastAssignmentsArray[indexPath.row]
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                displayAssignmentViewController.assignment = assignment
                displayAssignmentViewController.course = course
                displayAssignmentViewController.objectID = assignment.objectId
            }
        }
    }
    
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
}
extension PastAssignmentsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}