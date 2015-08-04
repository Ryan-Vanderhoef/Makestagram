//
//  NewGameViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/21/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {

    var newGame: GamePost?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var consoleTextField: UITextField!
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
        newGame = GamePost()
        newGame!.Title = titleTextField.text
        newGame!.Console = consoleTextField.text
        newGame!.Notes = notesTextView.text
        
        if statusSegmentedControl.selectedSegmentIndex == 0 {
            newGame!.Status = "Have Played"
        }
        else if statusSegmentedControl.selectedSegmentIndex == 1 {
            newGame!.Status = "To Play"
        }
        
        if ratingSegmentedControl.selectedSegmentIndex >= 1 {
            newGame!.Rating = Double(ratingSegmentedControl.selectedSegmentIndex)
        }
        else {
            newGame!.Rating = 42
        }
    }
    
}

extension NewGameViewController: UITextFieldDelegate {
    
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
