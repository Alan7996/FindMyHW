//
//  DisplayAssignmentTableViewController.swift
//  FindMyHW
//
//  Created by 수현 on 8/12/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class DisplayAssignmentTableViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var assignment: Assignment? {
        didSet {
            assignmentTitleText = assignment?.title
            assignmentInstructionText = assignment?.instruction
            dueDate = assignment?.dueDate
        }
    }
    var course: Course?
    var photo: Photo?
    
    // scratchpad value (for intermediate storage)
    var dueDate: NSDate?
    var assignmentTitleText: String?
    var assignmentInstructionText: String?
    
    var objectID: String?
    var parseAssignment: Assignment?
    let date = NSDate()
    var imageArray: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let assignment = assignment {
            let assignmentDueDate = assignment["dueDate"] as! NSDate
            if assignmentDueDate.laterDate(self.date).isEqualToDate(assignmentDueDate) {
                if course!.teacher == PFUser.currentUser() || assignment["user"].objectId == PFUser.currentUser()?.objectId{
                    saveButton.enabled = true
                }
            } else {
                saveButton.enabled = false
            }
        } else {
            saveButton.enabled = true
        }
            
        
        
        let currentCourseAssignmentsQuery = PFQuery(className: "Assignment")
        
        currentCourseAssignmentsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object.objectId == self.objectID {
                    self.parseAssignment = object as? Assignment
                }
            }
        }
        
        getPhotos()
    }
    
    func getPhotos() {
        self.imageArray = []
        
        let currentAssignmnetImagesQuery = PFQuery(className: "Photo")
        
        currentAssignmnetImagesQuery.includeKey("assignment")
        
        currentAssignmnetImagesQuery.findObjectsInBackgroundWithBlock{(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object["assignment"].objectId == self.assignment?.objectId {
                    self.imageArray.append(object as! Photo)
                }
            }
            
            print(self.imageArray.count)
            self.tableView.reloadData()
        }

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return imageArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // instantiate info cell
            let cell = tableView.dequeueReusableCellWithIdentifier("displayAssignmentInfoTableViewCell", forIndexPath: indexPath) as! DisplayAssignmentInfoTableViewCell
            
   
            cell.course = course
            if let assignment = assignment {
                cell.assignment = assignment
            }
        
            cell.delegate = self
            
            if assignmentTitleText != nil {
                cell.assignmentTitleTextField.text = assignmentTitleText
            } else if let assignment = assignment {
                cell.assignmentTitleTextField.text = assignment.title
            } else {
                cell.assignmentTitleTextField.text = ""
            }
            
            if assignmentInstructionText != nil {
                cell.assignmentInstructionTextView.text = assignmentInstructionText
            } else if let assignment = assignment {
                cell.assignmentInstructionTextView.text = assignment.instruction
            } else {
                cell.assignmentInstructionTextView.text = ""
            }
            
            
            if dueDate != nil {
                cell.assignmentDueDate.text = DateHelper.stringFromDate(dueDate!)
            } else if let assignment = assignment {
                cell.assignmentDueDate.text = DateHelper.stringFromDate(assignment.dueDate!)
            } else {
                cell.assignmentDueDate.text = ""
            }
            
            self.tableView.rowHeight = 370
            
            return cell
        }
        else {
            // instantiate image cell
            let cell = tableView.dequeueReusableCellWithIdentifier("displayAssignmentImageTableViewCell", forIndexPath: indexPath) as! DisplayAssignmentImageTableViewCell

            cell.course = course
            if let assignment = assignment {
                cell.assignment = assignment
            }
            
            cell.delegate = self
            
            cell.imageFile = imageArray[indexPath.row].imageFile
            cell.imageFile!.getDataInBackgroundWithBlock {(imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.assignmentImageView.image = UIImage(data: imageData!)
                    
                    cell.assignmentImageView.userInteractionEnabled = false
                }
            }
            
            self.tableView.rowHeight = 350
            
            return cell
        }
    }
    
    func addImage(sender: UIButton!) {
        print("Add Image tapped")
        photoTakingHelper = PhotoTakingHelper(viewController: self) { (image: UIImage?) in
            let alert: UIAlertView = UIAlertView(title: "Uploading Image", message: "Please wait...", delegate: nil, cancelButtonTitle: nil);
            
            AlertHelper.showAlert(alert, view: self.view)
            
            let newPhoto = Photo()

            newPhoto.imageFile = PFFile(data: UIImageJPEGRepresentation(image!, 1.0)!)
            newPhoto["assignment"] = self.assignment
            newPhoto.saveInBackgroundWithBlock{(success, error) in
                if success == true {
                    print("photo saved")
                    self.imageArray.append(newPhoto)
                    self.getPhotos()
                    alert.dismissWithClickedButtonIndex(-1, animated: true)
                } else {
                    print(error)
                }
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var assignmentDueDate = NSDate()
        if let assignment = assignment {
            assignmentDueDate = assignment["dueDate"] as! NSDate
        }
        if assignmentDueDate.laterDate(self.date).isEqualToDate(assignmentDueDate) {
            if section == 1{
                var footerView : UIView?
                footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
                
                let addImageBtn = UIButton(type: UIButtonType.System)
                
                addImageBtn.setTitle("Add Image", forState: UIControlState.Normal)
                addImageBtn.frame = CGRectMake(0, 0, tableView.frame.size.width, 30)
                addImageBtn.addTarget(self, action: #selector(DisplayAssignmentTableViewController.addImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                footerView?.addSubview(addImageBtn)
                
                return footerView
            }
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Save" {
            // if assignment exists, update title, instruction and due date
            print("save clicked")
            if let parseAssignment = assignment {
                
                parseAssignment.title = assignmentTitleText ?? ""
                parseAssignment.instruction = assignmentInstructionText ?? ""
                parseAssignment.dueDate = dueDate
                
                let alert: UIAlertView = UIAlertView(title: "Loading", message: "Please wait...", delegate: nil, cancelButtonTitle: nil);
                
                AlertHelper.showAlert(alert, view: self.view)
                
                parseAssignment.saveInBackgroundWithBlock{(success, error) in
                    if success == true {
                        print("\(parseAssignment) saved to parse")
                        print("save completed")
                        alert.dismissWithClickedButtonIndex(-1, animated: true)
                    } else {
                        print("save failed: \(error)")
                        alert.dismissWithClickedButtonIndex(-1, animated: true)
                        let alertController = UIAlertController(title: "Save Failed", message: "Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                // if assignment does not exist, create new assignment
                let newAssignment = Assignment()
                newAssignment.title = assignmentTitleText ?? ""
                newAssignment.instruction = assignmentInstructionText ?? ""
                newAssignment.dueDate = dueDate
                
                newAssignment.setObject(PFUser.currentUser()!, forKey: "user")
                newAssignment.setObject(course!, forKey: "course")
                
                let alert: UIAlertView = UIAlertView(title: "Loading", message: "Please wait...", delegate: nil, cancelButtonTitle: nil);
                
                AlertHelper.showAlert(alert, view: self.view)
                
                newAssignment.saveInBackgroundWithBlock{(success, error) in
                    if success == true {
                        print("\(newAssignment) saved to parse")
                        print("save completed")
                        alert.dismissWithClickedButtonIndex(-1, animated: true)
                    } else {
                        print("save failed: \(error)")
                        alert.dismissWithClickedButtonIndex(-1, animated: true)
                        let alertController = UIAlertController(title: "Save Failed", message: "Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else if segue.identifier == "setDueDate" {
            let setDueDateViewController = segue.destinationViewController as! SetDueDateViewController
            setDueDateViewController.assignmentObject = assignment
        }
    }
    
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "Save" {
            if assignmentTitleText == nil {
                let alert = UIAlertController(title: "No Title", message: "Please Set The Title", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
                
                return false
            } else if dueDate == nil {
                let alert = UIAlertController(title: "No Due Date", message: "Please Set The Due Date", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
                
                return false
            } else if assignmentInstructionText == "" {
                let alert = UIAlertController(title: "No Instruction", message: "Please Set The Instruction", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
                return false
            }
            else {
                return true
            }
        }
        // by default, transition
        return true
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
    }
}
extension DisplayAssignmentTableViewController: DisplayAssignmentImageCellDelegate {
    func displayAssignmentImageTableViewCellButtonPressed(displayAssignmentImageTableViewCell: DisplayAssignmentImageTableViewCell) {
        print("Remove Image button tapped")
        
        let alert = UIAlertController(title: "Delete Image", message: "This image will be permanently deleted", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
            let alert: UIAlertView = UIAlertView(title: "Deleting Image", message: "Please wait...", delegate: nil, cancelButtonTitle: nil);
            
            AlertHelper.showAlert(alert, view: self.view)
            
            for image in self.imageArray {
                if image.imageFile == displayAssignmentImageTableViewCell.imageFile {
                    image.deleteInBackgroundWithBlock{(success, error) in
                        if success == true {
                            print("photo deleted")
                            self.getPhotos()
                            alert.dismissWithClickedButtonIndex(-1, animated: true)
                        } else {
                            print(error)
                        }
                    }
                    
                }
            }
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
extension DisplayAssignmentTableViewController: DisplayAssignmentInfoCellDelegate {
    func updateTextField(cell: DisplayAssignmentInfoTableViewCell, newString: String) {
        print("updating textfield")
        assignmentTitleText = newString
    }
    func updateTextView(cell: DisplayAssignmentInfoTableViewCell, newString: String) {
        print("updating textview")
        assignmentInstructionText = newString
    }
}
