//
//  SelectedMovieViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/21/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse

class SelectedMovieViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    
    weak var movie: MoviePost?
    
    override func viewDidLoad() {
//        println("viewDidLoad - Movie - START")
        super.viewDidLoad()
        
        self.notesTextView.layer.cornerRadius = 5
        self.notesTextView.setContentOffset(CGPointMake(0,44), animated: false)
        
        titleTextField.text = movie?.Title
        yearTextField.text = movie?.Year
        //notesTextView.text = movie?.Notes
//        println("Problem - START")
        
//        if movie?.NotesFile.getData() != nil {
////            println("in here")
//            let data = (movie?.NotesFile.getData())!
//            movie?.notesText = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
//        }
//        else {
////            println("there")
//            movie?.notesText = ""
//        }
//        println("file contents = ")
//        println(movie?.notesText)
        movie?.NotesFile.getDataInBackgroundWithBlock({ (result: NSData?, error: NSError?) -> Void in
            //            println("IN HERE")
            //            if result != nil {
            //                println("results not nil")
            //            }
            //            else {
            //                println("results are nil")
            //            }
            //            let result = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
            //            println("String = \(result)")
            
            self.movie?.notesText = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
//            println(NSString(data: result!, encoding: NSUTF8StringEncoding) as! String)
            self.notesTextView.text = self.movie?.notesText
            
        })
//        println("Problem - END")
        
//        notesTextView.text = movie?.notesText   // Display .txt file text
        
        // Set correct movie Status segment
        if let identifier1 = movie?.Status {
            switch identifier1 {
                case "Have Watched":
                    statusSegmentedControl.selectedSegmentIndex = 0
                case "To Watch":
                    statusSegmentedControl.selectedSegmentIndex = 1
                default:
                    statusSegmentedControl.selectedSegmentIndex = 0
            }
        }
        
        // Set correct movie Rating segment
        let identifier2 = movie?.Rating
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
//        println("viewDidLoad - Movie - END")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.returnKeyType = .Next
        titleTextField.delegate = self
        yearTextField.returnKeyType = .Next
        yearTextField.delegate = self
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
        movie!.Title = titleTextField.text!
        movie!.Year = yearTextField.text
//        movie!.Notes = notesTextView.text
        movie!.notesText = notesTextView.text
//        movie!.notesText
//        movie!.NotesLowerCase = notesTextView.text.lowercaseString
        movie!.TitleLowerCase = titleTextField.text.lowercaseString
        
        if statusSegmentedControl.selectedSegmentIndex == 0 {
            movie!.Status = "Have Watched"
        }
        else if statusSegmentedControl.selectedSegmentIndex == 1 {
            movie!.Status = "To Watch"
        }
        if ratingSegmentedControl.selectedSegmentIndex >= 1 {
            movie!.Rating = Double(ratingSegmentedControl.selectedSegmentIndex)
        }
        else {
            movie!.Rating = 42    // if unrated, rating is stored as 42
        }
    }
    
}


extension SelectedMovieViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == titleTextField) {
            yearTextField.returnKeyType = .Next
            yearTextField.becomeFirstResponder()
        }
        else if (textField == yearTextField) {
            notesTextView.becomeFirstResponder()
        }
        else if (textField == notesTextView) {
        }
        
        return false
    }
    
}
