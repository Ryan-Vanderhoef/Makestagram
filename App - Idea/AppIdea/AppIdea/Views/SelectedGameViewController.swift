//
//  SelectedGameViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/21/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit

class SelectedGameViewController: UIViewController {

    weak var game: GamePost?
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var consoleTextField: UITextField!
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
//        println("viewDidLoad - Game - START")
        super.viewDidLoad()
        
        self.notesTextView.layer.cornerRadius = 5
        self.notesTextView.setContentOffset(CGPointMake(0,44), animated: false)
        
        titleTextField.text = game?.Title
        consoleTextField.text = game?.Console
//        notesTextView.text = game?.Notes
        
//        let data = (game?.NotesFile.getData())!    // Get NSData
//        if NSString(data: data, encoding: NSUTF8StringEncoding) == nil {
//            game?.notesText = ""
//        }
//        else {
//            game?.notesText = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
//        }
//        game?.notesText = (NSString(data: data, encoding: NSUTF8StringEncoding) as! String)  //?? "" // Convert NSData to String
        
//        println("Problem - START")
//        if game?.NotesFile.getData() != nil {
////            println("in here")
//            let data = (game?.NotesFile.getData())!
//            game?.notesText = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
//        }
//        else {
////            println("there")
//            game?.notesText = ""
//        }
        game?.NotesFile.getDataInBackgroundWithBlock({ (result: NSData?, error: NSError?) -> Void in
            //            println("IN HERE")
            //            if result != nil {
            //                println("results not nil")
            //            }
            //            else {
            //                println("results are nil")
            //            }
            //            let result = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
            //            println("String = \(result)")
            
            self.game?.notesText = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
//            println(NSString(data: result!, encoding: NSUTF8StringEncoding) as! String)
            self.notesTextView.text = self.game?.notesText
            
        })
//        println("Problem - END")
//        println("file contents =")
//        println(game?.notesText)
        
//        notesTextView.text = game?.notesText
        
        // Set correct game Status segment
        if let identifier1 = game?.Status {
            switch identifier1 {
                case "Have Played":
                    statusSegmentedControl.selectedSegmentIndex = 0
                case "To Play":
                    statusSegmentedControl.selectedSegmentIndex = 1
            default:
                statusSegmentedControl.selectedSegmentIndex = 0
            }
        }
        
        // Set correct game Rating segment
        let identifier2 = game?.Rating
        if identifier2 == 5.0 {
            ratingSegmentedControl.selectedSegmentIndex = 5
        }
        else if identifier2 == 4.0 {
            ratingSegmentedControl.selectedSegmentIndex = 4
        }
        else if identifier2 == 3.0 {
            ratingSegmentedControl.selectedSegmentIndex = 3
        }
        else if identifier2 == 2.0 {
            ratingSegmentedControl.selectedSegmentIndex = 2
        }
        else if identifier2 == 1.0 {
            ratingSegmentedControl.selectedSegmentIndex = 1
        }
        else  {
            ratingSegmentedControl.selectedSegmentIndex = 0
        }
//        println("viewDidLoad - Game - END")
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.returnKeyType = .Next
        titleTextField.delegate = self
        consoleTextField.returnKeyType = .Next
        consoleTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        game!.Title = titleTextField.text
        game!.Console = consoleTextField.text
//        game!.Notes = notesTextView.text
        game!.notesText = notesTextView.text
        game!.TitleLowerCase = titleTextField.text.lowercaseString
        game!.ConsoleLowerCase = consoleTextField.text.lowercaseString
//        game!.NotesLowerCase = notesTextView.text.lowercaseString
        
        if statusSegmentedControl.selectedSegmentIndex == 0 {
            game!.Status = "Have Played"
        }
        else if statusSegmentedControl.selectedSegmentIndex == 1 {
            game!.Status = "To Play"
        }
        if ratingSegmentedControl.selectedSegmentIndex >= 1 {
            game!.Rating = Double(ratingSegmentedControl.selectedSegmentIndex)
        }
        else {
            game!.Rating = 42    // if unrated, rating is stored as 42
        }
    }
    
}


extension SelectedGameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == titleTextField) {
            consoleTextField.returnKeyType = .Next
            consoleTextField.becomeFirstResponder()
        }
        else if (textField == consoleTextField) {
            notesTextView.becomeFirstResponder()
        }
        else if (textField == notesTextView) {
        }
        
        return false
    }
}
