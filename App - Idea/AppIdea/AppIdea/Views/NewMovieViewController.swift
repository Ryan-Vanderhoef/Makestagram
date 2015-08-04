//
//  NewMovieViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/21/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit

class NewMovieViewController: UIViewController {
    
    var newMovie: MoviePost?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.notesTextView.layer.cornerRadius = 5
        self.notesTextView.setContentOffset(CGPointMake(0,44), animated: false)
        
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
        newMovie = MoviePost()
        newMovie!.Title = titleTextField.text
        newMovie!.Year = yearTextField.text
        newMovie!.Notes = notesTextView.text
        
        if statusSegmentedControl.selectedSegmentIndex == 0 {
            newMovie!.Status = "Have Watched"
        }
        else if statusSegmentedControl.selectedSegmentIndex == 1 {
            newMovie!.Status = "To Watch"
        }
        
        if ratingSegmentedControl.selectedSegmentIndex >= 1 {
            newMovie!.Rating = Double(ratingSegmentedControl.selectedSegmentIndex)
        }
        else {
            newMovie!.Rating = 42    // if unrated, rating is stored as 42
        }
    }
    
}

extension NewMovieViewController: UITextFieldDelegate {
    
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
