//
//  DisplayAssignmentViewController.swift
//  FindMyHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import UIKit
import Parse

class DisplayAssignmentViewController: UIViewController {
    @IBOutlet weak var assignmentTitleTextField: UITextField!
    @IBOutlet weak var assignmentInstructionTextView: UITextView!
    @IBOutlet weak var assignmentModificationTimeLabel: UILabel!
    @IBOutlet weak var assignmentDueDate: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var assignment: Assignment?
    var course: Course?
    var dueDate: NSDate?
    var objectID: String?
    var parseAssignment: Assignment?
    let date = NSDate()
    var imageFile: PFFile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let assignment = assignment {
            let assignmentDueDate = assignment["dueDate"] as! NSDate
            if assignmentDueDate.laterDate(self.date).isEqualToDate(assignmentDueDate) {
                if course!.teacher == PFUser.currentUser() || assignment["user"].objectId == PFUser.currentUser()?.objectId{
                    assignmentTitleTextField.userInteractionEnabled = true
                    assignmentInstructionTextView.userInteractionEnabled = true
                    calendarButton.userInteractionEnabled = true
                    saveButton.enabled = true
                    uploadImageButton.enabled = true
                    removeImageButton.enabled = true
                }
            } else {
                assignmentTitleTextField.userInteractionEnabled = false
                assignmentInstructionTextView.userInteractionEnabled = false
                calendarButton.userInteractionEnabled = false
                saveButton.enabled = false
                uploadImageButton.enabled = false
                removeImageButton.enabled = false
            }
        } else {
            assignmentTitleTextField.userInteractionEnabled = true
            assignmentInstructionTextView.userInteractionEnabled = true
            calendarButton.userInteractionEnabled = true
            saveButton.enabled = true
            uploadImageButton.enabled = true
            removeImageButton.enabled = true
        }
        
        if assignment?.imageFile == nil {
            scrollView.scrollEnabled = false
            removeImageButton.enabled = false
        }
        
        dueDate = assignment?.dueDate
        
        self.assignmentInstructionTextView.layer.borderWidth = 0.5
        self.assignmentInstructionTextView.layer.borderColor = (UIColor( red: 0.5, green: 0.5, blue:0.5, alpha: 0.5 )).CGColor
        self.assignmentInstructionTextView.layer.cornerRadius = 10
        
        if let assignment = assignment {
            assignmentTitleTextField.text = assignment.title
            assignmentInstructionTextView.text = assignment.instruction
            assignmentDueDate.text = DateHelper.stringFromDate(assignment.dueDate!)
            if let imageFile = assignment.valueForKey("imageFile") as? PFFile {
                imageFile.getDataInBackgroundWithBlock{ (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.imageView.image = UIImage(data: imageData!)
                    }
                }
            }
            
        } else {
            assignmentTitleTextField.text = ""
            assignmentInstructionTextView.text = ""
            assignmentDueDate.text = ""
        }
        
        let currentCourseAssignmentsQuery = PFQuery(className: "Assignment")
        
        currentCourseAssignmentsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object.objectId == self.objectID {
                    self.parseAssignment = object as? Assignment
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        self.scrollView.contentSize.height = 720
    }
    
    @IBAction func uploadeImageButtonClicked(sender: AnyObject) {
        photoTakingHelper = PhotoTakingHelper(viewController: self) { (image: UIImage?) in
            self.imageFile = PFFile(data: UIImageJPEGRepresentation(image!, 1.0)!)
            self.imageView.image = image
            self.scrollView.scrollEnabled = true
            self.removeImageButton.enabled = true
        }
    }
    
    @IBAction func removeImageButtonClicked(sender: AnyObject) {
        self.imageFile = nil
        self.imageView.image = nil
        assignment?.imageFile = nil
//        self.scrollView.scrollEnabled = false
        self.removeImageButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "Save" {
            // if assignment exists, update title, instruction and due date
            print("save clicked")
            if let parseAssignment = assignment {
                
                parseAssignment.title = assignmentTitleTextField.text ?? ""
                parseAssignment.instruction = assignmentInstructionTextView.text ?? ""
                parseAssignment.dueDate = dueDate
                parseAssignment.imageFile = imageFile
                
                let alert: UIAlertView = UIAlertView(title: "Loading", message: "Please wait...", delegate: nil, cancelButtonTitle: nil);
                
                AlertHelper.showAlert(alert, view: self.view)
                
                parseAssignment.saveInBackgroundWithBlock{(success, error) in
                    if success == true {
                        print("save completed")
                        print("\(parseAssignment) saved to parse")
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
                newAssignment.title = assignmentTitleTextField.text ?? ""
                newAssignment.instruction = assignmentInstructionTextView.text ?? ""
                newAssignment.dueDate = dueDate
                newAssignment.imageFile = imageFile
                
                newAssignment.setObject(PFUser.currentUser()!, forKey: "user")
                newAssignment.setObject(course!, forKey: "course")
                
                let alert: UIAlertView = UIAlertView(title: "Loading", message: "Please wait...", delegate: nil, cancelButtonTitle: nil);
                
                AlertHelper.showAlert(alert, view: self.view)
                
                newAssignment.saveInBackgroundWithBlock{(success, error) in
                    if success == true {
                        print("save completed")
                        print("\(newAssignment) saved to parse")
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
            if assignmentTitleTextField.text == "" {
                let alert = UIAlertView()
                alert.title = "No Title"
                alert.message = "Please Set The Title"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            } else if dueDate == nil {
                let alert = UIAlertView()
                alert.title = "No Due Date"
                alert.message = "Please Set The Due Date"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            } else if assignmentInstructionTextView.text == "" {
                let alert = UIAlertView()
                alert.title = "No Instruction"
                alert.message = "Please Set The Instruction"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
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
