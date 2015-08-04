//
//  FriendsViewController.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/23/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse

class FriendsViewController: UIViewController {

    @IBOutlet weak var friendsTableView: UITableView!
    var users: [PFUser]?    // All users
//    var followingUsers: [PFUser]? {
//        didSet {
//            friendsTableView.reloadData()
//        }
//    }
    
//    @IBOutlet weak var segmentedControl: UISegmentedControl!
//    @IBAction func segmentedControlAction(sender: AnyObject) {
////        println("seg pressed")
//        viewDidAppear(true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.friendsTableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //let friendPostQuery = PFQuery(className: "FriendRelation")
        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            // Only want my friends
//            let friendPostQuery = PFQuery(className: "FriendRelation")
////            println("first: \(friendPostQuery)")
//            friendPostQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
////            println("second: \(friendPostQuery)")
//            friendPostQuery.selectKeys(["toUser"])
////            println("thrid: \(friendPostQuery)")
//            friendPostQuery.orderByAscending("fromUser")
////            println("fourth: \(friendPostQuery)")
//            friendPostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
////                println("results: \(result)")
//                self.users = result as? [PFUser] ?? []
////                println("in here")
////                println("\(self.users)")
//                self.friendsTableView.reloadData()
//            }
//            
//        }
//        else if segmentedControl.selectedSegmentIndex == 1 {
            // Want all users
        
        
        
            let friendPostQuery = PFUser.query()!
            friendPostQuery.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)   // exclude the current user
            friendPostQuery.orderByAscending("username")    // Order first by username, alphabetically
            friendPostQuery.addAscendingOrder("ObjectId")   // Then order by ObjectId, alphabetically
            friendPostQuery.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
//                println("qwerty: \(result)")
                self.users = result as? [PFUser] ?? []
                self.friendsTableView.reloadData()
            }
        
        
        
//        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as! FriendsTableViewCell
        
//        cell.titleLabel!.text = "\(moviePosts[indexPath.row].Title)"
//        cell.yearLabel!.text = "\(moviePosts[indexPath.row].Year)"
//        cell.statusLabel!.text = "\(moviePosts[indexPath.row].Status)"
        cell.friendsLabel!.text = "\(self.users![indexPath.row].username!)"
        //cell.friendsLabel!.text = "hello"
        
//        let query = PFQuery(className: "FriendRelation")
//        let test = PFQuery(className: "user")
//        println("good1")
//        var name = test.getObjectInBackgroundWithId(users![indexPath.row].objectId!) as! PFObject
//        println("good2")
//        query.whereKey("toUser", equalTo: name)
//        println("good3")
//        query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
//        println("good4")
//        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
////            println("qwerty: \(result)")
////            self.users = result as? [PFUser] ?? []
////            self.friendsTableView.reloadData()
//            println("toUser: \(self.users![indexPath.row].username!)")
//            println(result)
//            
//        }
        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            // Color To Watch movies as gray
//            if moviePosts[indexPath.row].Status == "To Watch" {
//                cell.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.06)
//            }
//                // Color Have Watched movies as white
//            else if moviePosts[indexPath.row].Status == "Have Watched" {
//                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
//            }
//        }
//        else {
//            // Color all movies white
//            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
//        }
//        
//        if moviePosts[indexPath.row].Status == "Have Watched" {
//            // If a movie has been watched, show rating
//            var rate = moviePosts[indexPath.row].Rating
//            if rate == 1      {cell.ratingLabel!.text = "Rating: ★☆☆☆☆"}
//            else if rate == 2 {cell.ratingLabel!.text = "Rating: ★★☆☆☆"}
//            else if rate == 3 {cell.ratingLabel!.text = "Rating: ★★★☆☆"}
//            else if rate == 4 {cell.ratingLabel!.text = "Rating: ★★★★☆"}
//            else if rate == 5 {cell.ratingLabel!.text = "Rating: ★★★★★"}
//            else              {cell.ratingLabel!.text = ""}
//            
//        }
//        else {
//            // If a movie has not been watched, don't show a rating
//            cell.ratingLabel!.text = ""
//        }
        
        return cell
}
}
