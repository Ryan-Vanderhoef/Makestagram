//
//  LoginView.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/28/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse

class LoginView: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func LogInButtonAction(sender: AnyObject) {
//        println("Log In Is Happening!")
        
        LogIn()
        
    }
    
//    @IBAction func SignUpButtonAction(sender: AnyObject) {
//        println("Sign Up Is Happening!")
//        
//        SignUp()
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if PFUser.currentUser() != nil {
//            println("user is here")
//            println("\(PFUser.currentUser())")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
//            // 3
//            //                    self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
//            self.presentViewController(tabBarController, animated:true, completion:nil)
//        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If user is already logged in, skip login screen
        if PFUser.currentUser() != nil {
//            println("user is here")
//            println("\(PFUser.currentUser())")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
            // 3
            //                    self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
            self.presentViewController(tabBarController, animated:true, completion:nil)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameTextField.returnKeyType = .Next
        usernameTextField.delegate = self
        passwordTextField.returnKeyType = .Next
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func LogIn() {
        var user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
//        println("username: \(usernameTextField.text)")
//        println("password: \(passwordTextField.text)")
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text, block: {
            (User: PFUser?, Error: NSError?) -> Void in
            
            if Error == nil {
                dispatch_async(dispatch_get_main_queue()){
//                    println("in here")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
                    // 3
//                    self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
                    self.presentViewController(tabBarController, animated:true, completion:nil)
                }
            }
            else {
                println("Something went wrong with user Log In")
            }
            
        })
        
        
    }
    
//    func SignUp() {
//        var user = PFUser()
//        user.username = usernameTextField.text
//        user.password = passwordTextField.text
//        user.email = emailTextField.text
//        
//        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if error == nil {
//                // Hooray! Let them use the app now.
//            } else {
//                // Examine the error object and inform the user.
//            }
//        }
//        
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == usernameTextField) {
            passwordTextField.returnKeyType = .Next
            passwordTextField.becomeFirstResponder()
        }
        else if (textField == passwordTextField) {
            usernameTextField.returnKeyType = .Next
            usernameTextField.becomeFirstResponder()
        }
        
        return false
    }
    
}
