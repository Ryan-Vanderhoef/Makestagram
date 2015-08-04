//
//  SelectedBookViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/15/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse

class SelectedBookViewController: UIViewController {
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    
    weak var book: BookPost?
    
    override func viewDidLoad() {
//        println("viewDidLoad - Book - START")
        super.viewDidLoad()
        
        self.notesTextView.layer.cornerRadius = 5
        self.notesTextView.setContentOffset(CGPointMake(0,44), animated: false)
        
        titleTextField.text = book?.Title
//        notesTextView.text = book?.Notes
        authorTextField.text = book?.Author
        
//        println("Problem - START")
//        if book?.NotesFile.getData() != nil {
////            println("in here")
//            let data = (book?.NotesFile.getData())!
////            book?.notesText = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
//        }
//        else {
////            println("there")
////            book?.notesText = ""
//        }
        book?.NotesFile.getDataInBackgroundWithBlock({ (result: NSData?, error: NSError?) -> Void in
//            println("IN HERE")
//            if result != nil {
//                println("results not nil")
//            }
//            else {
//                println("results are nil")
//            }
//            let result = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
//            println("String = \(result)")
            
            self.book?.notesText = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
//            println(NSString(data: result!, encoding: NSUTF8StringEncoding) as! String)
            self.notesTextView.text = self.book?.notesText
            
        })
//        println("Problem - END")
//        println("file contents =")
//        println(book?.notesText)
        
//        notesTextView.text = book?.notesText
        
        // Set correct book Status segment
        if let identifier1 = book?.Status {
            switch identifier1 {
                case "Have Read":
                    statusSegmentedControl.selectedSegmentIndex = 0;
                case "To Read":
                    statusSegmentedControl.selectedSegmentIndex = 1;
                default:
                statusSegmentedControl.selectedSegmentIndex = 0;
            }
        }
        
        // Set correct book Rating segment
        let identifier2 = book?.Rating
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
        else {
            ratingSegmentedControl.selectedSegmentIndex = 0;
        }
//        println("viewDidLoad - Book - END")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        titleTextField.returnKeyType = .Next
        titleTextField.delegate = self
        authorTextField.returnKeyType = .Next
        authorTextField.delegate = self
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
        book!.Title = titleTextField.text
        book!.Author = authorTextField.text
//        book!.Notes = notesTextView.text
        book!.notesText = notesTextView.text
        
//        book!.NotesLowerCase = notesTextView.text.lowercaseString
        book!.TitleLowerCase = titleTextField.text.lowercaseString
        book!.AuthorLowerCase = authorTextField.text.lowercaseString
        
        if statusSegmentedControl.selectedSegmentIndex == 0 {
            book!.Status = "Have Read"
        }
        else if statusSegmentedControl.selectedSegmentIndex == 1 {
            book!.Status = "To Read"
        }
        
        if ratingSegmentedControl.selectedSegmentIndex >= 1 {
            book!.Rating = Double(ratingSegmentedControl.selectedSegmentIndex)
        }
        else {
            book!.Rating = 42    // if unrated, rating is stored as 42
        }
    }

}


extension SelectedBookViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if (textField == titleTextField) {
            authorTextField.returnKeyType = .Next
            authorTextField.becomeFirstResponder()
        }
        else if (textField == authorTextField) {
            notesTextView.becomeFirstResponder()
        }
        else if (textField == notesTextView) {
        }
        
        return false
    }
    
}
