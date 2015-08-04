//
//  MoviesViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/15/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse

class MoviesViewController: UIViewController {
    
    var selectedMovie: MoviePost?
    
    @IBOutlet weak var searchBar: UISearchBar!
    enum State {
        case DefaultMode
        case SearchMode
    }
    var state: State = .DefaultMode
    
    @IBOutlet weak var moviesTableView: UITableView!
    var moviePosts: [MoviePost] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentedControlAction(sender: AnyObject) {
        viewDidAppear(true) // Reset the view every time the segment is pressed!
    }
    
    func searchMovies(searchString: String) -> [MoviePost] {
//        println("In Search with String = \(searchString)")
        
        let yearQuery = PFQuery(className: "MoviePost")     // Query for matching year
        yearQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        yearQuery.whereKey("Year", containsString: searchString.lowercaseString)
        let titleQuery = PFQuery(className: "MoviePost")    // Query for matching Title
        titleQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        titleQuery.whereKey("TitleLowerCase", containsString: searchString.lowercaseString)
        
        
        
//        let notesQuery = PFQuery(className: "MoviePost")    // Query for matching Notes
//        notesQuery.whereKey("user", equalTo: PFUser.currentUser()!)
//        notesQuery.whereKey("NotesLowerCase", containsString: searchString.lowercaseString)
        
        
        
        // Combine Year, Title, and Notes queries
        let moviePostQuery = PFQuery.orQueryWithSubqueries([yearQuery, titleQuery, ])//notesQuery])
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // Have Watched and To Watch movies
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            moviePostQuery.whereKey("Status", equalTo: "Have Watched")  // Only Have Watched movies
        }
        else if segmentedControl.selectedSegmentIndex == 2 {
            moviePostQuery.whereKey("Status", equalTo: "To Watch")      // Only To Watch movies
        }
        
        moviePostQuery.orderByAscending("Title")    // Order first by Title, alphabetically
        moviePostQuery.addAscendingOrder("Year")    // Then order by Year, alphabetically
//        moviePostQuery.addAscendingOrder("Notes")   // Then order by Notes, alphabetically
        
        // Search for movies matching the queries
        moviePostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.moviePosts = result as? [MoviePost] ?? []
            self.moviesTableView.reloadData()
        }
        
        return self.moviePosts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.moviesTableView.tableHeaderView = self.searchBar    // Add searchBar to table view header
        
        // Do any additional setup after loading the view.
    }

//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        let moviePostQuery = PFQuery(className: "MoviePost")  // Create query to search for movie posts
//        moviePostQuery.whereKey("user", equalTo: PFUser.currentUser()!)  // Only from the current user
//        if(segmentedControl.selectedSegmentIndex == 0) {
//            // Have Watched and To Watch movies
//        }
//        else if segmentedControl.selectedSegmentIndex == 1 {
//            moviePostQuery.whereKey("Status", equalTo: "Have Watched")  // Only Have Watched movies
//        }
//        else if segmentedControl.selectedSegmentIndex == 2 {
//            moviePostQuery.whereKey("Status", equalTo: "To Watch")      // Only To Watch movies
//        }
//        
//        moviePostQuery.orderByAscending("Title")    // Order first by Title, alphabetically
//        moviePostQuery.addAscendingOrder("Year")    // Then order by Year, alphabetically
//        moviePostQuery.addAscendingOrder("Notes")   // Then order by Notes, alphabetically
//        
//        // Search for movies matching queries
//        moviePostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
//            self.moviePosts = result as? [MoviePost] ?? []
//            self.moviesTableView.reloadData()
//        }
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let moviePostQuery = PFQuery(className: "MoviePost")  // Create query to search for movie posts
        moviePostQuery.whereKey("user", equalTo: PFUser.currentUser()!)  // Only from the current user
        
        if searchBar.text == "" {
            self.moviesTableView.setContentOffset(CGPointMake(0,44), animated: false)    // Hide searchBar if not searching
            searchBar.delegate = self
            self.moviesTableView.tableHeaderView = self.searchBar    // Add searchBar to table view header
            // Normal query if nothing in searchBar
            if(segmentedControl.selectedSegmentIndex == 0) {
                // Have Watched and To Watch movies
            }
            else if segmentedControl.selectedSegmentIndex == 1 {
                moviePostQuery.whereKey("Status", equalTo: "Have Watched")  // Only Have Watched movies
            }
            else if segmentedControl.selectedSegmentIndex == 2 {
                moviePostQuery.whereKey("Status", equalTo: "To Watch")    // Only To Watch movies
            }
            
            moviePostQuery.orderByAscending("Title") // Order first by Title, alphabetically
            moviePostQuery.addAscendingOrder("Year") // Then order by Year, alphabetically
//            moviePostQuery.addAscendingOrder("Notes") // Then order by Notes, alphabetically
            
            
            // Search for movies matching queries
            moviePostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
                self.moviePosts = result as? [MoviePost] ?? []
                self.moviesTableView.reloadData()
            }
        }
        else {
            // Search bar query if something in searchBar
            searchMovies(searchBar.text)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        state = .DefaultMode
//        println("prepare for segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToSelectedMovie" {
//            println("segueToSelectedMovie")
            let movieViewController = segue.destinationViewController as! SelectedMovieViewController
            let indexPath = moviesTableView.indexPathForSelectedRow()
            self.moviesTableView.deselectRowAtIndexPath(indexPath!, animated: false)
            let selectedMovie = moviePosts[indexPath!.row]
            movieViewController.movie = selectedMovie
        }
    }
    
}


extension MoviesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviePosts.count ?? 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MoviesTableViewCell
        
        cell.titleLabel!.text = "\(moviePosts[indexPath.row].Title)"
        cell.yearLabel!.text = "\(moviePosts[indexPath.row].Year)"
        cell.statusLabel!.text = "\(moviePosts[indexPath.row].Status)"
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // Color To Watch movies as gray
            if moviePosts[indexPath.row].Status == "To Watch" {
                cell.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.06)
            }
            // Color Have Watched movies as white
            else if moviePosts[indexPath.row].Status == "Have Watched" {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
            }
        }
        else {
            // Color all movies white
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
        }
        
        if moviePosts[indexPath.row].Status == "Have Watched" {
            // If a movie has been watched, show rating
            var rate = moviePosts[indexPath.row].Rating
            if rate == 1      {cell.ratingLabel!.text = "Rating: ★☆☆☆☆"}
            else if rate == 2 {cell.ratingLabel!.text = "Rating: ★★☆☆☆"}
            else if rate == 3 {cell.ratingLabel!.text = "Rating: ★★★☆☆"}
            else if rate == 4 {cell.ratingLabel!.text = "Rating: ★★★★☆"}
            else if rate == 5 {cell.ratingLabel!.text = "Rating: ★★★★★"}
            else              {cell.ratingLabel!.text = ""}
            
        }
        else {
            // If a movie has not been watched, don't show a rating
            cell.ratingLabel!.text = ""
        }
        
        return cell
    }
    
    @IBAction func unwindToSegueMovie(segue: UIStoryboardSegue) {
//        println("Movie: UnwindToSegue")
        if let identifier = segue.identifier {
            //println("Identifier \(identifier)")
            switch identifier{
                case "SaveMovie":   // Save movie when "Save" is pressed in NewMovieViewController
//                    println("SaveMOVIE")
                    let source = segue.sourceViewController as! NewMovieViewController
                    let saveMovie = PFObject(className:  "MoviePost")
                    
                    saveMovie["Title"] = source.newMovie!.Title
                    saveMovie["Year"] = source.newMovie!.Year
                    saveMovie["Status"] = source.newMovie!.Status
//                    saveMovie["Notes"] = source.newMovie!.Notes
            
                    let str = source.newMovie!.Notes
                    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
                    let file = PFFile(name: "notes.txt", data: data!)
                    saveMovie["NotesFile"] = file
                    
                    
                    saveMovie["Rating"] = source.newMovie!.Rating
                    saveMovie["user"] = PFUser.currentUser()
                    saveMovie["TitleLowerCase"] = source.newMovie!.Title.lowercaseString
//                    saveMovie["NotesLowerCase"] = source.newMovie!.Notes.lowercaseString
                    
                    saveMovie.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("savemovie has been saved.")
                    }
                case "DoneMovie":   // Resave movie when "Done" is pressed in SelectedMovieViewController
//                    println("DoneMovie button pressed")
                    let source = segue.sourceViewController as! SelectedMovieViewController
                    
                    let str = source.movie!.notesText
                    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
                    let file = PFFile(name: "notes.txt", data: data!)
                    source.movie!.NotesFile = file
                    
                    source.movie?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("updateMovie has been saved.")
                    }
                case "TrashMovie":  // Delete movie if the Trash Can is pressed in SelectedMovieViewController
//                    println("TrashMovie pressed")
                    let source = segue.sourceViewController as! SelectedMovieViewController
                    source.movie?.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("Movie has been deleted.")
                    }
                default:
                    println("No one loves \(identifier)")
            }
        }
    }
    
}


extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        println("searchBarTextDidBeginEditing")
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //        println("searchBarCancelButtonClicked")
        self.moviesTableView.setContentOffset(CGPointMake(0,44), animated: true)
        self.searchBar.resignFirstResponder()
        state = .DefaultMode
        self.searchBar.text = ""
        viewDidAppear(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        println("searchBar")
        self.moviePosts = searchMovies(searchText)
    }
    
}


extension MoviesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Get MoviePost(PFObject) of selected cell
//            var delMovie = PFQuery(className: "MoviePost").getObjectWithId(moviePosts[indexPath.row].objectId!) as! MoviePost
//            delMovie.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
////                println("Movie has been deleted.")
//                self.viewDidAppear(true)
//            }
//        }
//    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            PFQuery(className: "MoviePost").getObjectInBackgroundWithId(moviePosts[indexPath.row].objectId!, block: {(result: AnyObject?, error: NSError?) -> Void in
                var delMovie = result as! PFObject
                delMovie.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    self.viewDidAppear(true)
                }
            })
        }
    }
    
    
}
