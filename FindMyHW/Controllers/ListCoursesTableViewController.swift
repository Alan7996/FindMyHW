//
//  ListCoursesTableViewController.swift
//  FindMyHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import UIKit
import Parse

var globalCourses: [Course] = []

class ListCoursesTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var addCourseBtn: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCourses = [Course]()
    
    var refreshControl1: UIRefreshControl!
    
    var courses: [Course] = []

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
            addCourseBtn.enabled = true
        } else {
            addCourseBtn.enabled = false
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        navigationController?.navigationBar.barTintColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        
        refreshControl1 = UIRefreshControl()
        refreshControl1.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl1.addTarget(self, action: #selector(ListCoursesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func refresh() {
        courses = []
        
        let currentUserCoursesQuery = PFQuery(className: "Course")
        
        currentUserCoursesQuery.includeKey("teacher")
        
        currentUserCoursesQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object["school"].objectId == PFUser.currentUser()?["school"].objectId && (object["studentRelation"].containsObject((PFUser.currentUser()?.username)!) || object["teacher"].objectId == PFUser.currentUser()!.objectId) {
                    self.courses.append(object as! Course)
                }
            }
            
            self.courses.sortInPlace({ $0.name!.compare($1.name!) == NSComparisonResult.OrderedAscending})
            
            self.tableView.reloadData()
            
            globalCourses = self.courses
            
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
        
        return courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCoursesTableViewCell", forIndexPath: indexPath) as! ListCoursesTableViewCell
        
        let course: Course
        
        if searchController.active && searchController.searchBar.text != "" {
            course = filteredCourses[indexPath.row]
        } else if courses != [] {
            course = courses[indexPath.row]
            // app crashes when swiped twice with "fatal eror: Index out of range"
            // issue is still not fixed and needs to be fixed in future
        } else{
            course = globalCourses[indexPath.row]
        }
        
        cell.course = course
        cell.delegate = self
        
        cell.isLockedBtn.tag = indexPath.row
        
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            let course = courses[indexPath.row]
            if course.teacher == PFUser.currentUser() {
                let alert = UIAlertController(title: "Delete", message: "This course will be permanently deleted along with its assignments.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                    print("\(course.name) deleted")
                    ParseHelper.deleteObjectInBackgroundWithBlock(course)
                    let currentCourseAssignmentsQuery = PFQuery(className: "Assignment")
                    
                    currentCourseAssignmentsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
                        for object in result! {
                            if object["course"].objectId == course.objectId {
                                ParseHelper.deleteObjectInBackgroundWithBlock(object)
                            }
                        }
                    }
                    self.refresh()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                    print("\(course.name) delete canceled")
                }))
                presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Unenroll", message: "You will now unenroll from this course.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                    let newArray = course["studentRelation"] as! [String]
                    let filteredArray = newArray.filter() { $0 != PFUser.currentUser()?.username! }
                    course["studentRelation"] = filteredArray
                    ParseHelper.saveObjectInBackgroundWithBlock(course)
                    let delay = 0.1 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        print("PLZ")
                        self.refresh()
                    })

                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                    print("\(course.name) unenroll canceled")
                }))
                presentViewController(alert, animated: true, completion: nil)
            }
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
            addCourseBtn.addTarget(self, action: #selector(ListCoursesTableViewController.addCourse(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            footerView?.addSubview(addCourseBtn)
            
            return footerView
        } else {
            return footerView
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
            }
        }
    }

    func addCourse(sender: UIButton!) {
        print("Add Course tapped")
        self.performSegueWithIdentifier("searchToAddCourse", sender: sender)
        //also need a functionality to delete the user's name from the array
    }
    
    func goBackToSchoolViewController() {
        if let currentUser = PFUser.currentUser() {
            currentUser.removeObjectForKey("school")
            
            ParseHelper.saveObjectInBackgroundWithBlock(currentUser)
        }
        let schoolViewController = storyboard?.instantiateViewControllerWithIdentifier("ListSchoolTableViewController") as! UINavigationController
        UIApplication.sharedApplication().delegate?.window??.rootViewController = schoolViewController
    }
    
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    @IBAction func unenrollClicked(sender: AnyObject) {
        let alertController = UIAlertController(title: "Are You Sure?", message: "You are about to unenroll from your school. This action cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action -> Void in
            self.goBackToSchoolViewController()
        })
        
        self.presentViewController(alertController, animated: true, completion: nil)
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

extension ListCoursesTableViewController: ListCoursesTableViewCellDelegate {
    func listCoursesTableViewCellButtonPressed(listCoursesTableViewCell: ListCoursesTableViewCell) {
        let courseBtnBelongsTo = listCoursesTableViewCell.course!
        
        if courseBtnBelongsTo["isLocked"] as! Int == 1 {
            courseBtnBelongsTo["isLocked"] = 0
            courseBtnBelongsTo.saveInBackgroundWithBlock{(success, error) in
                if success == true {
                    print("save completed")
                    print("\(courseBtnBelongsTo) saved to parse")
                    self.tableView.reloadData()
                } else {
                    print("save failed: \(error)")
                    let alertController = UIAlertController(title: "Save Failed", message: "Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        } else {
            courseBtnBelongsTo["isLocked"] = 1
            courseBtnBelongsTo.saveInBackgroundWithBlock{(success, error) in
                if success == true {
                    print("save completed")
                    print("\(courseBtnBelongsTo) saved to parse")
                    self.tableView.reloadData()
                } else {
                    print("save failed: \(error)")
                    let alertController = UIAlertController(title: "Save Failed", message: "Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}