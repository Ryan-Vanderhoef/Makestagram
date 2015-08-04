//
//  BookPost.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/15/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import Foundation
import Parse

class BookPost : PFObject, PFSubclassing {
    
    @NSManaged var Title: String
    @NSManaged var Author: String
    @NSManaged var Rating: Double
    @NSManaged var Notes: String
    @NSManaged var Status: String
    @NSManaged var ISBN: String
    @NSManaged var user: PFUser?
    @NSManaged var NotesFile: PFFile
    
    
    @NSManaged var NotesLowerCase: String
    @NSManaged var TitleLowerCase: String
    @NSManaged var AuthorLowerCase: String
    
    var notesText: String = ""
    
    //MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "BookPost"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
}
