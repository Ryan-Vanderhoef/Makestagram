//
//  BooksViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/15/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BooksViewController: UIViewController, UITableViewDelegate {
    
    var selectedBook: BookPost?
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var booksTableView: UITableView!
    var bookPosts: [BookPost] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentedControlAction(sender: AnyObject) {
        viewDidAppear(true) // Reset the view every time the segment is pressed!
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    enum State {
        case DefaultMode
        case SearchMode
    }
    var state: State = .DefaultMode
    
    func searchBooks(searchString: String) -> [BookPost] {
//        println("In Search with String = \(searchString)")
        let authorQuery = PFQuery(className: "BookPost")    // Query for matching Author
        authorQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        authorQuery.whereKey("AuthorLowerCase", containsString: searchString.lowercaseString)
        let titleQuery = PFQuery(className: "BookPost")     // Query for matching Title
        titleQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        titleQuery.whereKey("TitleLowerCase", containsString: searchString.lowercaseString)
//        let notesQuery = PFQuery(className: "BookPost")     // Query for matching Notes
//        notesQuery.whereKey("user", equalTo: PFUser.currentUser()!)
//        notesQuery.whereKey("NotesLowerCase", containsString: searchString.lowercaseString)
        
        // Combine Author, Title, and Notes queries
        let bookPostQuery = PFQuery.orQueryWithSubqueries([authorQuery, titleQuery, ])//notesQuery])
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // Have Read and To Read books
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            bookPostQuery.whereKey("Status", equalTo: "Have Read")  // Only Have Read books
        }
        else if segmentedControl.selectedSegmentIndex == 2 {
            bookPostQuery.whereKey("Status", equalTo: "To Read")    // Only To Read books
        }
        
        bookPostQuery.orderByAscending("Author") // Order first by Title, alphabetically
        bookPostQuery.addAscendingOrder("Title") // Then order by Author, alphabetically
//        bookPostQuery.addAscendingOrder("Notes") // Then order by Notes, alphabetically
        
        // Search for books matching the queries
        bookPostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.bookPosts = result as? [BookPost] ?? []
            self.booksTableView.reloadData()
        }

        return self.bookPosts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.booksTableView.delegate = self
        searchBar.delegate = self
        self.booksTableView.tableHeaderView = self.searchBar    // Add searchBar to table view header
        // Do any additional setup after loading the view.
//        println("VIEW DID LOAD")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
//        println("HERE HERE HERE HERE HERE HERE HERE HERE HERE HERE HERE HERE HERE HERE ")
        
//        println("\(PFUser.currentUser())")
        
//        if PFUser.currentUser() == nil {
//            
//            var logInViewController = PFLogInViewController()
//            logInViewController.delegate = self
//            var signUpViewController = PFSignUpViewController()
//            signUpViewController.delegate = self
//            
//            logInViewController.signUpController = signUpViewController
//            
//            self.presentViewController(logInViewController, animated: true, completion: nil)
//            
//        }
        
//        println("Books viewDidAppear")
//        println("User: \(PFUser.currentUser())")
        
        let bookPostQuery = PFQuery(className: "BookPost")  // Create query to search for book posts
        bookPostQuery.whereKey("user", equalTo: PFUser.currentUser()!)  // Only from the current user
        
        if searchBar.text == "" {
            self.booksTableView.setContentOffset(CGPointMake(0,44), animated: false)    // Hide searchBar if not searching
            // Normal query if nothing in searchBar
            if(segmentedControl.selectedSegmentIndex == 0) {
                // Have Read and To Read books
            }
            else if segmentedControl.selectedSegmentIndex == 1 {
                bookPostQuery.whereKey("Status", equalTo: "Have Read")  // Only Have Read books
            }
            else if segmentedControl.selectedSegmentIndex == 2 {
                bookPostQuery.whereKey("Status", equalTo: "To Read")    // Only To Read books
            }
            
            bookPostQuery.orderByAscending("Author") // Order first by Author, alphabetically
            bookPostQuery.addAscendingOrder("Title") // Then order by Title, alphabetically
//            bookPostQuery.addAscendingOrder("Notes") // Then order by Notes, alphabetically
            
            
            // Search for books matching queries
            bookPostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
                self.bookPosts = result as? [BookPost] ?? []
                self.booksTableView.reloadData()
            }
        }
        else {
            // Search bar query if something in searchBar
            searchBooks(searchBar.text)
        }
//        booksTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        state = .DefaultMode
        
        if segue.identifier == "segueToSelectedBook"{
            let bookViewController = segue.destinationViewController as! SelectedBookViewController
            bookViewController.book = selectedBook
        }
    }

}


extension BooksViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedBook = bookPosts[indexPath.row] as BookPost
        
        self.booksTableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        self.performSegueWithIdentifier("segueToSelectedBook", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookPosts.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        println("tableView - cellForRowAtIndexPath")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell") as! BooksTableViewCell
        
        cell.titleLabel!.text = "\(bookPosts[indexPath.row].Title)"
        cell.authorLabel!.text = "\(bookPosts[indexPath.row].Author)"
        cell.statusLabel!.text = "\(bookPosts[indexPath.row].Status)"
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // Color To Read books as gray
            if bookPosts[indexPath.row].Status == "To Read" {
                cell.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.06)
            }
            // Color Have Read books as white
            else if bookPosts[indexPath.row].Status == "Have Read" {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
            }
        }
        else {
            // Color all books as white
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
        }
        
        if bookPosts[indexPath.row].Status == "Have Read" {
            // If book has been read, show rating
            var rate = bookPosts[indexPath.row].Rating
            if rate == 1      {cell.ratingLabel!.text = "Rating: ★☆☆☆☆"}
            else if rate == 2 {cell.ratingLabel!.text = "Rating: ★★☆☆☆"}
            else if rate == 3 {cell.ratingLabel!.text = "Rating: ★★★☆☆"}
            else if rate == 4 {cell.ratingLabel!.text = "Rating: ★★★★☆"}
            else if rate == 5 {cell.ratingLabel!.text = "Rating: ★★★★★"}
            else              {cell.ratingLabel!.text = "Not Yet Rated"}
            
        }
        else {
            // If book has not been read, don't show a rating
            cell.ratingLabel!.text = ""
        }
        
        return cell
    }
    
    @IBAction func unwindToSegueBook(segue: UIStoryboardSegue) {
//        println("Book: UnwindToSegue")
        if let identifier = segue.identifier {
            switch identifier{
                case "SaveBook":    // Save book when "Save" is pressed in NewBookViewController
//                    println("Save button pressed")
                    let source = segue.sourceViewController as! NewBookViewController
                    let saveBook = PFObject(className:  "BookPost")
                    
                    saveBook["Title"] = source.newBook!.Title
                    saveBook["Author"] = source.newBook!.Author
                    saveBook["Status"] = source.newBook!.Status
//                    saveBook["Notes"] = source.newBook!.Notes
                    
                    let str = source.newBook!.Notes
                    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
                    let file = PFFile(name: "notes.txt", data: data!)
                    saveBook["NotesFile"] = file
                    
                    saveBook["Rating"] = source.newBook!.Rating
                    saveBook["user"] = PFUser.currentUser()
//                    saveBook["NotesLowerCase"] = source.newBook!.Notes.lowercaseString
                    saveBook["TitleLowerCase"] = source.newBook!.Title.lowercaseString
                    saveBook["AuthorLowerCase"] = source.newBook!.Author.lowercaseString
                    
                    saveBook.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("saveBook has been saved.")
                }
                case "DoneBook":    // Resave book when "Done" is pressed in SelectedBookViewController
//                    println("Done button pressed")
                    let source = segue.sourceViewController as! SelectedBookViewController
                    
                    let str = source.book!.notesText
                    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
                    let file = PFFile(name: "notes.txt", data: data!)
                    source.book!.NotesFile = file
                    
//                    println("source: \(source.book!.Title)")
//                    println("source: \(source.book!.objectId)")
//                    /*
//                    var test : String = "testing"
//                    println(test)
//                    test = test.stringByReplacingOccurrencesOfString("ing", withString: "")
//                    println(test)
//                    
//                    var bookId = "\(source.book!.objectId)"
//                    var bookId = source.book?.objectId
//                    println(bookId)
//                    bookId = bookId.stringByReplacingOccurrencesOfString("Optional(\"", withString: "")
//                    println(bookId)
//                    bookId = bookId.stringByReplacingOccurrencesOfString("\")", withString: "")
//                    println(bookId)
//                    bookId = bookId.stringByReplacingOccurrencesOfString("\"", withString: "")
//                    println(bookId)
//                    
//                    println("selectedBook Id = \(selectedBook?.objectId)")
//                    let updateBookQuery = PFQuery(className: "BookPost")
//                    updateBook.whereKey("ObjectId", equalTo: "\(selectedBook?.objectId)")
//                    updateBook.getObjectInBackgroundWithId("\(selectedBook?.objectId)")
//                    let updateBook = updateBookQuery.getObjectWithId(bookId)
//                    println("\(updateBook)")
//                    let testQuery = PFQuery(className: "BookPost")
//                    let testBook = testQuery.getObjectWithId("ob59xWVCX2")
//                           println(testBook)
//                println("\(updateBook)")
//                    updateBook?["Title"] = "newTitle"
//                    updateBook?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("updateBook has been saved.")
//                }*/
//                
//                    source.book?.Title = "newTitle"
                    
                    source.book?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("updateBook has been saved.")
                    }
                case "TrashBook":   // Delete book if the Trash Can is pressed in SelectedBookViewController
//                    println("Trash button pressed")
                    let source = segue.sourceViewController as! SelectedBookViewController
//                    println("TrashBook has been pressed")
                    source.book?.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("Book has been deleted.")
                    }
//                    println("Trashbook - deleteInBackgroundWithBlock has completed")
                default:
                    println("No one loves \(identifier)")
            }
        }
    }
    
}


extension BooksViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        println("searchBarTextDidBeginEditing")
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //        println("searchBarCancelButtonClicked")
        self.booksTableView.setContentOffset(CGPointMake(0,44), animated: true)
        self.searchBar.resignFirstResponder()
        state = .DefaultMode
        self.searchBar.text = ""
        viewDidAppear(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        println("searchBar")
        self.bookPosts = searchBooks(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        println("Search button pressed")
        self.bookPosts = searchBooks(searchBar.text)
    }
    
}


extension BooksViewController: UITableViewDelegate {
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Get BookPost(PFObject) of selected cell
//            println("getting object starting")
//            var delBook = PFQuery(className: "BookPost").getObjectWithId(bookPosts[indexPath.row].objectId!) as! BookPost
//            var delBook = PFQuery(className: "BookPost").getObjectInBackgroundWithId(bookPosts[indexPath.row].objectId!) as! BookPost
            PFQuery(className: "BookPost").getObjectInBackgroundWithId(bookPosts[indexPath.row].objectId!, block: {(result: AnyObject?, error: NSError?) -> Void in
//                println("deleteing book starting")
                var delBook = result as! PFObject
                delBook.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                  println("Book has been deleted.")
                    self.viewDidAppear(true)
                }
            })
//            println("getting object ending")
//            delBook.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                println("Book has been deleted.")
//                self.viewDidAppear(true)
//            }
        }
    }
    
}

extension BooksViewController: PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        }
        else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        println("didLogInUser")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        
//        println("Failed to Login")
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        
        if let password = info["password"] as? String {
            return true  //password.utf16Count >= 8
        }
        else {
            return false
        }
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
//        println("Failed to sign up")
        
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
//        println("User dismissed sign up")
        
    }
}

