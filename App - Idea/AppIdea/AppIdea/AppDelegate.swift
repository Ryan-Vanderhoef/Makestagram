//
//  AppDelegate.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/14/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//
/*
import UIKit
import Parse
import Bolts
import FBSDKCoreKit
import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    var parseLoginHelper: ParseLoginHelper!
//
    override init() {
        super.init()
//
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
//                ErrorHandling.defaultErrorHandler(error)
                println("error")
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
                // 3
                self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Change color of the Tab Bar items - White when not selected, gray when selected
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState:.Selected)
        
        // Change color of the staus bar - White
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // Set up the Parse SDK
        Parse.setApplicationId("EpqYUoWXidSNoklehCwCqjkuDg8lQGZkPN3U3xwl",
            clientKey: "gkPgln2TS1L9Pro1EoPryjFoullFZ92RuRcDZLmN")
        
        // Might Cause Error (?)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Test user
//        PFUser.logInWithUsername("Ryan", password: "password")
//        if let user = PFUser.currentUser() {
//            println("Log in successful")
//        } else {
//            println("No logged in user :(")
//        }
        
//        // Initialize Facebook
//        // 1
//        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
//        
        // check if we have logged in user
//         2
//        let user = PFUser.currentUser()
//
//        let startViewController: UIViewController;
//
//        if (user != nil) {
//            // 3
//            // if we have a user, set the TabBarController to be the initial View Controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
//        } else {
//            // 4
//            // Otherwise set the LoginViewController to be the first
////            let loginView = UIStoryboard(name: "login", bundle: nil)
////            let thing = loginView.instantiateViewControllerWithIdentifier("LoginView") as! UIViewController
////            thing.presetViewController(loginView, animated:true, completion:nil)
//            // 3
//            //                    self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
////            self.presentViewController(thing, animated:true, completion:nil)
////            self.window?.rootViewController!.presentViewController(loginView, animated:true, completion:nil)
//            
//            let loginViewController = PFLogInViewController()
//            loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
//            loginViewController.delegate = parseLoginHelper
//            loginViewController.signUpController?.delegate = parseLoginHelper
////
//            startViewController = loginViewController
//        }
//
//        // 5
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.rootViewController = startViewController;
//        self.window?.makeKeyAndVisible()
        
        return true
//        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

    }
    
//    //MARK: Facebook Integration
//    
//    func applicationDidBecomeActive(application: UIApplication) {
//        FBSDKAppEvents.activateApp()
//    }
//    
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//    }

    
    

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
*/
import UIKit
import Parse
import Bolts
//import FBSDKCoreKit
import ParseUI

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        println("in here")
        
        
        
        // Change color of the Tab Bar items - White when not selected, gray when selected
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState:.Selected)
        
        // Change color of the staus bar - White
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // Set up the Parse SDK
        Parse.setApplicationId("EpqYUoWXidSNoklehCwCqjkuDg8lQGZkPN3U3xwl", clientKey: "gkPgln2TS1L9Pro1EoPryjFoullFZ92RuRcDZLmN")
        
        
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        // Might Cause Error (?)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
//        println("\(PFUser.currentUser())")
         // Test user
//                PFUser.logInWithUsername("Ryan", password: "password")
//                if let user = PFUser.currentUser() {
//                    println("Log in successful")
//                } else {
//                    println("No logged in user :(")
//                }
//        
//        return true
        
        
        
        
//        let user = PFUser.currentUser()
//        
//        let startViewController: UIViewController
//
//        if (user != nil) {
//            println("AppDelegate: user != nil")
//            // 3
//            // if we have a user, set the TabBarController to be the initial View Controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
//        } else {
//            println("AppDelegate: user == nil")
////            // 4
////            // Otherwise set the LoginViewController to be the first
////            println("user is nil")
//            let loginViewController = PFLogInViewController()
////            let signUpViewController = PFSignUpViewController()
////            loginViewController.signUpController = signUpViewController
////            
////            startViewController = loginViewController
//////            loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
//////            loginViewController.delegate = parseLoginHelper
//////            loginViewController.signUpController?.delegate = parseLoginHelper
////            
//            startViewController = loginViewController
//        }
////
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



