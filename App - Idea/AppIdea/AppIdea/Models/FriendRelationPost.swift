//
//  FriendRelationPost.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/23/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import Foundation
import Parse

class FriendRelationPost : PFObject, PFSubclassing {
    
    @NSManaged var fromUser: PFUser?
    @NSManaged var toUser: PFUser?
    
    //MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "FriendRelation"
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
