//
//  UserProfileViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/7/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserProfileViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        
        titleLabel.text = PFUser.currentUser()!["title"] as? String
        let userFirstName = PFUser.currentUser()!["firstName"] as! String
        let userLastName = PFUser.currentUser()!["lastName"] as! String
        nameLabel.text = userFirstName + " " + userLastName
        emailLabel.text = PFUser.currentUser()!["email"] as? String
        
        let userSchool = PFQuery(className: "School")
        userSchool.whereKey("objectId", equalTo: (PFUser.currentUser()?["school"].objectId)!)
        do {
            let schoolName = try userSchool.findObjects().first
            
            schoolLabel.text = schoolName!["schoolName"] as? String
        } catch {
            print(error)
        }
        
        if PFUser.currentUser()!["isTeacher"] as! Int == 1 {
            positionLabel.text = "Teacher"
            userImage.image = UIImage(named: "Teacher")
        } else {
            positionLabel.text = "Student"
            userImage.image = UIImage(named: "Student")
        }
    }
    
    @IBAction func logOutButtonClicked(sender: AnyObject) {
        let alertController = UIAlertController(title: "Are You Sure?", message: "You are about to log out.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action -> Void in
            PFUser.logOut()
            let loginViewController = self.createLoginViewController()
            print(#function, "logout --> show login view controller: \(loginViewController.delegate)")
            UIApplication.sharedApplication().delegate?.window??.rootViewController = loginViewController
        })
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func createLoginViewController() -> PFLogInViewController {
        // Otherwise set the LoginViewController to be the first
        let loginViewController = PFLogInViewController()
        
        let logInLogoTitle = UILabel()
        LogoHelper.createLogo("What's The HW", label: logInLogoTitle)
        loginViewController.logInView?.logo = logInLogoTitle
        
        let imageName = "Icon.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        // checks screen size of user's device and changes size of the image accordingly
        var imageSideValue = 150
        if UIScreen.mainScreen().bounds.height == 480 {
            imageSideValue = 100
        } else if UIScreen.mainScreen().bounds.height == 568 {
            imageSideValue = 150
        } else if UIScreen.mainScreen().bounds.height == 667 {
            imageSideValue = 200
        } else if UIScreen.mainScreen().bounds.height == 736 {
            imageSideValue = 250
        }
        imageView.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - CGFloat(imageSideValue/2), 10, CGFloat(imageSideValue), CGFloat(imageSideValue))
        
        loginViewController.view.addSubview(imageView)
        
        loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten]
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        loginViewController.delegate =  appDelegate.parseLoginHelper
        loginViewController.signUpController?.delegate = appDelegate.parseLoginHelper
        loginViewController.view.backgroundColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        
        loginViewController.logInView!.logInButton?.setBackgroundImage(nil, forState: .Normal)
        loginViewController.logInView!.logInButton?.backgroundColor = UIColor(red: CGFloat(91.0/255.0), green: CGFloat(124.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        loginViewController.logInView!.logInButton?.layer.cornerRadius = 5
        loginViewController.logInView!.logInButton?.layer.borderWidth = 1
        loginViewController.logInView!.logInButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        //            loginViewController.logInView!.passwordForgottenButton?.backgroundColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        
        let signUpLogoTitle = UILabel()
        LogoHelper.createLogo("What's The HW", label: signUpLogoTitle)
        loginViewController.signUpController!.signUpView?.logo = signUpLogoTitle
        loginViewController.signUpController!.signUpView?.backgroundColor = UIColor(red: CGFloat(91.0/255.0), green: CGFloat(124.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        
        return loginViewController
        
    }
    
}
