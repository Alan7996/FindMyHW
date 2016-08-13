//
//  ListSchoolTableViewController.swift
//  FindMyHW
//
//  Created by 수현 on 8/4/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import UIKit
import Parse

class ListSchoolTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var addSchoolBtn: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredSchools = [School]()
    
    var refreshControl1: UIRefreshControl!
    
    var schools: [School] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var isTeacher: AnyObject?
        let userQuery = PFUser.query()
        userQuery?.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        do {
            let user = try userQuery?.findObjects().first as! PFUser
            
            isTeacher = user["isTeacher"]
        } catch {
            print(error)
        }
        print(PFUser.currentUser()!)
        print(isTeacher)
        if isTeacher as! NSObject == 1 {
            addSchoolBtn.enabled = true
        } else {
            addSchoolBtn.enabled = false
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        refreshControl1 = UIRefreshControl()
        refreshControl1.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl1.addTarget(self, action: #selector(ListCoursesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl1)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }
    
    func refresh() {
        schools = []
        
        let allSchoolsQuery = PFQuery(className: "School")
        
        allSchoolsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                self.schools.append(object as! School)
            }
            
            self.schools.sortInPlace({ $0.schoolName!.compare($1.schoolName!) == NSComparisonResult.OrderedAscending})
            
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
            return filteredSchools.count
        }
        
        return schools.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listSchoolTableViewCell", forIndexPath: indexPath) as! ListSchoolTableViewCell
        
        let school: School
        
        if searchController.active && searchController.searchBar.text != "" {
            school = filteredSchools[indexPath.row]
        } else {
            school = schools[indexPath.row]
        }
        
        cell.school = school
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let school = self.schools[indexPath.row]
        PFUser.currentUser()?.setObject(school, forKey: "school")
        ParseHelper.saveObjectInBackgroundWithBlock(PFUser.currentUser()!)
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            let school = schools[indexPath.row]
            school.deleteInBackground()
            self.refresh()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "addSchool" {
                print("+ button tapped")
            } else if identifier == "displaySchool" {
                print("display school")
            }
        }
    }
    
    @IBAction func unwindToListSchoolViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredSchools = schools.filter { school in
            return school.schoolName!.lowercaseString.containsString(searchText.lowercaseString) || school.cityName!.lowercaseString.containsString(searchText.lowercaseString) || school.country!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
}
extension ListSchoolTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
