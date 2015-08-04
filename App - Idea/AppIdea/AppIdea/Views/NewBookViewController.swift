//
//  NewBookViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/16/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit

class NewBookViewController: UIViewController {

    var newBook: BookPost?
    
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    @IBOutlet weak var ratingSegmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.noteTextView.layer.cornerRadius = 5
        self.noteTextView.setContentOffset(CGPointMake(0,44), animated: false)
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
        newBook = BookPost()
        newBook!.Title = titleTextField.text
        newBook!.Author = authorTextField.text
        newBook!.Notes = noteTextView.text
        
        if statusSegmentControl.selectedSegmentIndex == 0 {
            newBook!.Status = "Have Read"
        }
        else if statusSegmentControl.selectedSegmentIndex == 1 {
            newBook!.Status = "To Read"
        }
        
        if ratingSegmentControl.selectedSegmentIndex >= 1 {
            newBook!.Rating = Double(ratingSegmentControl.selectedSegmentIndex)
        }
        else {
            newBook!.Rating = 42    // if unrated, rating is stored as 42
        }
    }

}

extension NewBookViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == titleTextField) {
            authorTextField.returnKeyType = .Next
            authorTextField.becomeFirstResponder()
        }
        else if (textField == authorTextField) {
            noteTextView.becomeFirstResponder()
        }
        else if (textField == noteTextView) {
        }
        
        return false
    }
    
}
