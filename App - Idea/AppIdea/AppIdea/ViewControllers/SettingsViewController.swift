//
//  SettingsViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/23/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse
import Realm

class SettingsViewController: UIViewController {
    
//    var pref = Preferences()
    
//    var orderBookFirst: String = "Title"
//    var orderBookSecond: String = "Author"
    
//    var orderMovieFirst: String 
//    var orderMovieSecond: String
//    
//    var orderGameFirst: String
//    var OrderGameSecond: String
    
    @IBOutlet weak var tabBarSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var bookOrderSegmentedControl: UISegmentedControl!
    @IBAction func bookOrderSegmentedControlAction(sender: AnyObject) {
        if bookOrderSegmentedControl.selectedSegmentIndex == 0 {
//            self.orderBookFirst = "Title"
//            self.orderBookSecond = "Author"
//            pref.orderBookFirst = "Title"
//            pref.orderBookSecond = "Author"
        }
        else {
//            pref.orderBookFirst = "Author"
//            pref.orderBookSecond = "Title"
//            self.orderBookFirst = "Author"
//            self.orderBookSecond = "Title"
        }
    }
    
    @IBOutlet weak var movieOrderSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var gameOrderSegmentedControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func LogOutButtonAction(sender: AnyObject) {
//        println("logout is happening")
//        PFUser.logOutInBackgroundWithBlock({
//            (Error: NSError?) -> Void in
//            println("logging out")
//            // Segue to login view
//            println("made it here")
//        
//        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSegueSettings(segue: UIStoryboardSegue) {
//        println("unwindToSegueSettings")
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
//        println("SETTINGS PREPAREFORSEGUE")
        if segue.identifier == "LogOutSegue" {
//                println("logout is happening")
                PFUser.logOutInBackgroundWithBlock({
                    (Error: NSError?) -> Void in
//                    println("logging out")
                    // Segue to login view
//                    println("made it here")
                
                })
        }
//        println("LOGOUT DONE?")
    }


}
