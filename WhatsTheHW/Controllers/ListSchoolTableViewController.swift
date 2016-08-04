//
//  ListSchoolTableViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/4/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class ListSchoolTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    var filteredSchools = [School]()
    
    var refreshControl1: UIRefreshControl!
    
    var schools: [School] = []
    
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
        
        schools = []
        
        let allSchoolsQuery = PFQuery(className: "School")
        
        allSchoolsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                self.schools.append(object as! School)
            }
            
            self.schools.sortInPlace({ $0.schoolName!.compare($1.schoolName!) == NSComparisonResult.OrderedAscending})
            
            self.tableView.reloadData()
        }

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
        
        cell.schoolNameLabel.text = school.schoolName
        
        let schoolAddress = school.cityName! + ", " + school.country!
        
        cell.schoolAddressLabel.text = schoolAddress
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let school = schools[indexPath.row]
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
            //            RealmHelper.deleteCourse(courses[indexPath.row])
            //            courses = RealmHelper.retrieveCourses()
        }
    }
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        var footerView : UIView?
//        footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
//        
//        if searchController.searchBar.text == "" {
//            let addCourseBtn = UIButton(type: UIButtonType.System)
//            //            addCourseBtn.backgroundColor = UIColor.grayColor()
//            addCourseBtn.setTitle("Add School", forState: UIControlState.Normal)
//            addCourseBtn.frame = CGRectMake(0, 0, tableView.frame.size.width, 50)
//            addCourseBtn.addTarget(self, action: "addSchool:", forControlEvents: UIControlEvents.TouchUpInside)
//            
//            footerView?.addSubview(addCourseBtn)
//            
//            return footerView
//        } else {
//            return footerView
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "addSchool" {
                print("+ button tapped")
            }
        }
    }
    
//    func addSchool(sender: UIButton!) {
//        print("Add School tapped")
//        self.performSegueWithIdentifier("searchToAddSchool", sender: sender)
//        //add functionality to append the course's name to school array
//        //also need a functionality to delete the all courses related to school
//        //possibly create a new viewcontroller to handle all of these
//    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        viewWillAppear(true)
        refreshControl1.endRefreshing()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredSchools = schools.filter { school in
            return school.schoolName!.lowercaseString.containsString(searchText.lowercaseString)
//                || school.cityName!.lowercaseString.containsString(searchText.lowercaseString) || school.country!.lowercaseString.containsString(searchText.lowercaseString)
            // also need to search cityName and country
        }
        
        tableView.reloadData()
    }
}
extension ListSchoolTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}