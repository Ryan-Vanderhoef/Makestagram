//
//  MasterTabBarViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/29/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MasterTabBarViewController: UITabBarController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        println("view appeared MASTERTABBARCONTROLLER")
        
//        println("\(PFUser.currentUser())")
        
//        if PFUser.currentUser() == nil {
//            
//            var logInViewController = PFLogInViewController()
//            logInViewController.delegate = self
//            var signUpViewController = PFSignUpViewController()
//            signUpViewController.delegate = self
//            
//            logInViewController.signUpController = signUpViewController
//            
//            self.presentViewController(logInViewController, animated: true, completion: nil)
//            
//            
//        }
//        super.viewDidAppear(animated)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        }
        else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        println("didLogInUser")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        
//        println("Failed to Login")
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        
        if let password = info["password"] as? String {
            return true  //password.utf16Count >= 8
        }
        else {
            return false
        }
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
//        println("Failed to sign up")
        
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
//        println("User dismissed sign up")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
