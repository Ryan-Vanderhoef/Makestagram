//
//  NewViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/29/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class NewViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        println("view appeared NEWVIEWCONTROLLER")
        
//        println("\(PFUser.currentUser())")
        
                if PFUser.currentUser() == nil {
        
                    var logInViewController = MyPFLogInViewController() //PFLogInViewController()
                    logInViewController.delegate = self
                    var signUpViewController = MyPFSignUpViewController() //PFSignUpViewController()
                    signUpViewController.delegate = self
        
                    logInViewController.signUpController = signUpViewController
                    logInViewController.fields = (PFLogInFields.UsernameAndPassword
                        | PFLogInFields.LogInButton
                        | PFLogInFields.SignUpButton
                        | PFLogInFields.PasswordForgotten
                        /*| PFLogInFields.DismissButton*/
                        /*| PFLogInFields.Facebook*/)
        
                    self.presentViewController(logInViewController, animated: true, completion: nil)
        
        
                }
                else {
                    
                    // Present BooksViewController if User is already Logged In
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let BooksViewController = storyboard.instantiateViewControllerWithIdentifier("BooksViewController") as! UIViewController
//                    self.presentViewController(BooksViewController, animated:true, completion:nil)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
                    // 3
                    //                    self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
                    self.presentViewController(tabBarController, animated:true, completion:nil)
                }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
//            println("done with shouldBeginLogInWithUsername true")
            return true
        }
        else {
//            println("done with shouldBeginLogInWithUsername false")
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        println("didLogInUser")
        self.dismissViewControllerAnimated(true, completion: nil)
//        println("done with didLogInUser")
        
//        // Present BooksViewController when Log In is completed
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let BooksViewController = storyboard.instantiateViewControllerWithIdentifier("BooksViewController") as! UIViewController
//        self.presentViewController(BooksViewController, animated:true, completion:nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
        // 3
        //                    self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
        self.presentViewController(tabBarController, animated:true, completion:nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        
//        println("Failed to Login")
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        
        if let password = info["password"] as? String {
//            println("done with shouldBeginSignUp true")
            return count(password) >= 8 //!password.isEmpty //> ""  //password.utf16Count >= 8
        }
        else {
//            println("done with should BeginSignUp false")
            return false
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
//        println("done with didSignUpUser")
        
//        // Present BooksViewController when Sign Up is completed
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let BooksViewController = storyboard.instantiateViewControllerWithIdentifier("BooksViewController") as! UIViewController
//        self.presentViewController(BooksViewController, animated:true, completion:nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
        // 3
        //                    self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
        self.presentViewController(tabBarController, animated:true, completion:nil)
        
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
