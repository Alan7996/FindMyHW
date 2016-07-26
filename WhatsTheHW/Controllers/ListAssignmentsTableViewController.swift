//
//  ListCoursesTableViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class ListAssignmentsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    var filteredAssignments = [Assignment]()
    
    var course: Course?
    var assignmentArray = [Assignment]()
    var assignments: Results<Assignment>! {
        didSet {
            assignmentArray = [Assignment]()
            for assignment in assignments {
                if assignment.assignmentClass == course!.name {
                    assignmentArray.append(assignment)
                }
            }
            print(assignmentArray)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredAssignments.count
        }
        
        if assignments != nil {
            print("return \(assignmentArray.count) rows")
            return assignmentArray.count
        } else {
            print("return 0 rows")
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listAssignmentsTableViewCell", forIndexPath: indexPath) as! ListAssignmentsTableViewCell
        
        let assignment: Assignment
        
        if searchController.active && searchController.searchBar.text != "" {
            assignment = filteredAssignments[indexPath.row]
        } else {
            assignment = assignmentArray[indexPath.row]
        }
        
        cell.assignmentNameLabel.text = assignment.title

        cell.assignmentModificationTimeLabel.text = assignment.modificationTime.convertToString()

        cell.assignmentInstructionLabel.text = assignment.instruction
        
        cell.assignmentInstructionLabel.numberOfLines = 0
        
        cell.assignmentInstructionLabel.frame = CGRectMake(20, 20, 200, 800)
        
        cell.assignmentInstructionLabel.sizeToFit()
        
        cell.assignmentDueDateLabel.text = assignment.dueDate
        
        return cell
    }
    
    func countAssignments() -> Int{
        if assignmentArray.count != 0 {
            return assignmentArray.count
        } else {
            return 0
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "addAssignment" {
                print("+ button tapped")
                
                print (assignmentArray.count)
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                displayAssignmentViewController.course = course

                print (course?.name)
                
            } else if identifier == "displayAssignment" {
                print("Table view cell tapped")
                let indexPath = tableView.indexPathForSelectedRow!
                let assignment = assignmentArray[indexPath.row]
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                displayAssignmentViewController.assignment = assignment
                displayAssignmentViewController.course = course
                print (course?.name)
            }
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            RealmHelper.deleteAssignment(assignments[indexPath.row])
            assignments = RealmHelper.retrieveAssignments()
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredAssignments = assignmentArray.filter { assignment in
            return assignment.title.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
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
