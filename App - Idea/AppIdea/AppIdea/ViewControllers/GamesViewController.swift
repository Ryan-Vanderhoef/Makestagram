//
//  GamesViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/15/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse

class GamesViewController: UIViewController {

    var selectedGame: GamePost?
    
    @IBOutlet weak var searchBar: UISearchBar!
    enum State {
        case DefaultMode
        case SearchMode
    }
    var state: State = .DefaultMode
    
    @IBOutlet weak var gamesTableView: UITableView!
    var gamePosts: [GamePost] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentedControlAction(sender: AnyObject) {
        viewDidAppear(true) // Reset the view every time the segment is pressed!
    }

    func searchGames(searchString: String) -> [GamePost] {
//        println("In Search with String = \(searchString)")
        
        let consoleQuery = PFQuery(className: "GamePost")   // Query for matching Console
        consoleQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        consoleQuery.whereKey("ConsoleLowerCase", containsString: searchString.lowercaseString)
        let titleQuery = PFQuery(className: "GamePost")     // Query for matching Title
        titleQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        titleQuery.whereKey("TitleLowerCase", containsString: searchString.lowercaseString)
//        let notesQuery = PFQuery(className: "GamePost")     // Query for matching Notes
//        notesQuery.whereKey("user", equalTo: PFUser.currentUser()!)
//        notesQuery.whereKey("NotesLowerCase", containsString: searchString.lowercaseString)
        
        // Combine Console, Title, and Notes queries
        let gamePostQuery = PFQuery.orQueryWithSubqueries([consoleQuery, titleQuery, ])//notesQuery])
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // Have Played and To Play games
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            gamePostQuery.whereKey("Status", equalTo: "Have Played")    // Only Have Played games
        }
        else if segmentedControl.selectedSegmentIndex == 2 {
            gamePostQuery.whereKey("Status", equalTo: "To Play")        // Only To Play games
        }
        
        gamePostQuery.orderByAscending("Title")     // Order first by Title, alphabetically
        gamePostQuery.addAscendingOrder("Console")  // Then order by Console, alphabetically
//        gamePostQuery.addAscendingOrder("Notes")    // Then order by Notes, alphabetically
        
        // Seach for games matching the queries
        gamePostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.gamePosts = result as? [GamePost] ?? []
            self.gamesTableView.reloadData()
        }
        
        return self.gamePosts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.gamesTableView.tableHeaderView = self.searchBar    // Add searchBar to table view header

        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        let gamePostQuery = PFQuery(className: "GamePost")  // Create query to search for game posts
//        gamePostQuery.whereKey("user", equalTo: PFUser.currentUser()!)  // Only from the current user
//        if(segmentedControl.selectedSegmentIndex == 0) {
//            // Have Played and To Play games
//        }
//        else if segmentedControl.selectedSegmentIndex == 1 {
//            gamePostQuery.whereKey("Status", equalTo: "Have Played")    // Only Have Played games
//        }
//        else if segmentedControl.selectedSegmentIndex == 2 {
//            gamePostQuery.whereKey("Status", equalTo: "To Play")        // Only To Play games
//        }
//        
//        gamePostQuery.orderByAscending("Title")     // Order first by Title, alphabetically
//        gamePostQuery.addAscendingOrder("Console")  // Then order by Console, alphabetically
//        gamePostQuery.addAscendingOrder("Notes")    // Then order by Notes, alphabetically
//        
//        // Search for games matching queries
//        gamePostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
//            self.gamePosts = result as? [GamePost] ?? []
//            self.gamesTableView.reloadData()
//        }
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let gamePostQuery = PFQuery(className: "GamePost")  // Create query to search for game posts
        gamePostQuery.whereKey("user", equalTo: PFUser.currentUser()!)  // Only from the current user
        
        if searchBar.text == "" {
            self.gamesTableView.setContentOffset(CGPointMake(0,44), animated: false)    // Hide searchBar if not searching
            searchBar.delegate = self
            self.gamesTableView.tableHeaderView = self.searchBar    // Add searchBar to table view header
            // Normal query if nothing in searchBar
            if(segmentedControl.selectedSegmentIndex == 0) {
                // Have Played and To Play games
            }
            else if segmentedControl.selectedSegmentIndex == 1 {
                gamePostQuery.whereKey("Status", equalTo: "Have Played")  // Only Have Played games
            }
            else if segmentedControl.selectedSegmentIndex == 2 {
                gamePostQuery.whereKey("Status", equalTo: "To Play")    // Only To Play games
            }
            
            gamePostQuery.orderByAscending("Title") // Order first by Title, alphabetically
            gamePostQuery.addAscendingOrder("Console") // Then order by Console, alphabetically
//            gamePostQuery.addAscendingOrder("Notes") // Then order by Notes, alphabetically
            
            
            // Search for games matching queries
            gamePostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
                self.gamePosts = result as? [GamePost] ?? []
                self.gamesTableView.reloadData()
            }
        }
        else {
            // Search bar query if something in searchBar
            searchGames(searchBar.text)
        }
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
//        println("in here")
        if segue.identifier == "segueToSelectedGame" {
//            println("segueToSelectedGame")
            let gameViewController = segue.destinationViewController as! SelectedGameViewController
            let indexPath = gamesTableView.indexPathForSelectedRow()
            self.gamesTableView.deselectRowAtIndexPath(indexPath!, animated: false)
            let selectedGame = gamePosts[indexPath!.row]
            gameViewController.game = selectedGame
        }
    }

}


extension GamesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamePosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameCell") as! GamesTableViewCell
        
        cell.titleLabel!.text = "\(gamePosts[indexPath.row].Title)"
        cell.consoleLabel!.text = "\(gamePosts[indexPath.row].Console)"
        cell.statusLabel!.text = "\(gamePosts[indexPath.row].Status)"
        
        if segmentedControl.selectedSegmentIndex == 0{
            // Color To Play games as gray
            if gamePosts[indexPath.row].Status == "To Play" {
                cell.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.06)
            }
            // Color Have Played games as white
            else if gamePosts[indexPath.row].Status == "Have Played" {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
            }
        }
        else {
            // Color all games white
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
        }
        
        if gamePosts[indexPath.row].Status == "Have Played" {
            // If game has been played, show rating
            var rate = gamePosts[indexPath.row].Rating
            if rate == 1      {cell.ratingLabel!.text = "Rating: ★☆☆☆☆"}
            else if rate == 2 {cell.ratingLabel!.text = "Rating: ★★☆☆☆"}
            else if rate == 3 {cell.ratingLabel!.text = "Rating: ★★★☆☆"}
            else if rate == 4 {cell.ratingLabel!.text = "Rating: ★★★★☆"}
            else if rate == 5 {cell.ratingLabel!.text = "Rating: ★★★★★"}
            else              {cell.ratingLabel!.text = ""}
            
        }
        else {
            // If game has not been played, don't show a rating
            cell.ratingLabel!.text = ""
        }
        
        return cell
    }
    
    @IBAction func unwindToSegueGame(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
//            println("Identifier \(identifier)")
            switch identifier{
                case "SaveGame":    // Save game when "Save" is pressed in NewGameViewController
//                    println("SaveGame")
                    let source = segue.sourceViewController as! NewGameViewController
                    let saveGame = PFObject(className:  "GamePost")
                
                    saveGame["Title"] = source.newGame!.Title
                    saveGame["Console"] = source.newGame!.Console
                    saveGame["Status"] = source.newGame!.Status
//                    saveGame["Notes"] = source.newGame!.Notes
                    
                    let str = source.newGame!.Notes
//                    println("str: \(str)")
                    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
                    let file = PFFile(name: "notes.txt", data: data!)
                    saveGame["NotesFile"] = file
                    
                    saveGame["Rating"] = source.newGame!.Rating
                    saveGame["user"] = PFUser.currentUser()
                    saveGame["TitleLowerCase"] = source.newGame!.Title.lowercaseString
                    saveGame["ConsoleLowerCase"] = source.newGame!.Console.lowercaseString
//                    saveGame["notesLowerCase"] = source.newGame!.Notes.lowercaseString
                
                    saveGame.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("savegame has been saved.")
                    }
                case "DoneGame":    // Resave game when "Done" is pressed in SelectedGameViewController
//                    println("DoneGame pressed")
                    let source = segue.sourceViewController as! SelectedGameViewController
                    
                    let str = source.game!.notesText
                    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
                    let file = PFFile(name: "notes.txt", data: data!)
                    source.game!.NotesFile = file
                    
                    source.game?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("updateGame has been saved.")
                    }
                case "TrashGame":   // Delete game if the Trash Can is pressed in SelectedGameViewController
//                    println("TrashGame pressed")
                    let source = segue.sourceViewController as! SelectedGameViewController
                    source.game?.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                        println("Game has been deleted.")
                    }
                default:
                    println("No one loves \(identifier)")
            }
        }
    }
    
}


extension GamesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        println("searchBarTextDidBeginEditing")
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //        println("searchBarCancelButtonClicked")
        self.gamesTableView.setContentOffset(CGPointMake(0,44), animated: true)
        self.searchBar.resignFirstResponder()
        state = .DefaultMode
        self.searchBar.text = ""
        viewDidAppear(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        println("searchBar")
        self.gamePosts = searchGames(searchText)
    }
    
}


extension GamesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Get GamePost(PFObject) of selected cell
//            var delGame = PFQuery(className: "GamePost").getObjectWithId(gamePosts[indexPath.row].objectId!) as! GamePost
//            delGame.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
////                println("Game has been deleted.")
//                self.viewDidAppear(true)
//            }
//        }
//    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            PFQuery(className: "GamePost").getObjectInBackgroundWithId(gamePosts[indexPath.row].objectId!, block: {(result: AnyObject?, error: NSError?) -> Void in
                var delGame = result as! PFObject
                delGame.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    self.viewDidAppear(true)
                }
            })
        }
    }
    
}
