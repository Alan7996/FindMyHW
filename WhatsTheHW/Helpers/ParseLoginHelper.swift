//
//  ParseLoginHelper.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/28/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import Parse
import ParseUI

typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

/**
 This class implements the 'PFLogInViewControllerDelegate' protocol. After a successfull login
 it will call the callback function and provide a 'PFUser' object.
 */
class ParseLoginHelper : NSObject {
    static let errorDomain = "com.makeschool.parseloginhelpererrordomain"
    static let usernameNotFoundErrorCode = 1
    static let usernameNotFoundLocalizedDescription = "Could not retrieve username"
    
    let callback: ParseLoginHelperCallback
    
    init(callback: ParseLoginHelperCallback) {
        self.callback = callback
    }
}
extension ParseLoginHelper : PFLogInViewControllerDelegate {

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        print("\(#function): successful login")
        self.callback(user, nil)
    }

}
extension ParseLoginHelper : PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.callback(user, nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let startViewController = storyboard.instantiateViewControllerWithIdentifier("ListSchoolTableViewController") as! UINavigationController
        let mainWindow = UIApplication.sharedApplication().delegate!.window!
        mainWindow?.rootViewController = startViewController
        
    }
    
}
