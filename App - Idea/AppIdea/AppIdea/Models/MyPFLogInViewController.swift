//
//  MyPFLogInViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/29/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MyPFLogInViewController: PFLogInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(red: 130/255, green: 207/255, blue: 253/255, alpha: 1.0) //UIColor.lightGrayColor() //UIColor(red: 192/255, green: 54/255, blue: 44/255, alpha: 1)
        
        let logoView = UIImageView(image: UIImage(named: "AntlerLogo"))
        self.logInView!.logo = logoView
        
//        self.logInView!.signUpButton?. = UIColor.yellowColor() //tintColor = UIColor.whiteColor()
//        self.logInView!.logInButton
//        self.logInView!.passwordForgottenButton
//        self.logInView!.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
