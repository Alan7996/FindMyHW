//
//  AppDelegate.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        
//        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
//            // Initialize the ParseLoginHelper with a callback
//            if let error = error {
//                ErrorHandling.defaultErrorHandler(error)
//            } else if let _ = user {
//                // if login was successful, display the TabBarController
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
//                self.window?.rootViewController!.presentViewController(tabBarController, animated: true, completion: nil)
//            }
//        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//         print(Realm.Configuration.defaultConfiguration.fileURL)
        
        Course.registerSubclass()
        Assignment.registerSubclass()
        
        // Set up the Parse SDK
        let configuration = ParseClientConfiguration {
            $0.applicationId = "WhatsTheHW"
            $0.server = "https://whatsthehw-parse-alan.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
        do {
            try PFUser.logInWithUsername("test", password: "test")
        } catch {
            print("Unable to log in")
        }
        
        if let currentUser = PFUser.currentUser() {
            print("\(currentUser.username!) logged in successfully")
        } else {
            print("No logged in user :(")
        }
        
        let acl = PFACL()
        acl.publicReadAccess = true
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        // check if we have logged in user
        
//        let user = PFUser.currentUser()
        
//        let startViewController: UIViewController
//        
//        if (user != nil) {
//            // if we have a user, set the TabBarController to be the initial view controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
//        } else {
//            // Otherwise set the LoginViewController to be the first
//            let loginViewController = PFLogInViewController()
//            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
//            loginViewController.delegate = parseLoginHelper
//            loginViewController.signUpController?.delegate = parseLoginHelper
//            
//            startViewController = loginViewController
//        }
//        
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.rootViewController = startViewController;
//        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

