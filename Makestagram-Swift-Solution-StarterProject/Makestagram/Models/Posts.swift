//
//  Posts.swift
//  Makestagram
//
//  Created by Ryan Vanderhoef on 6/26/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit

// 1 - Inherit from PFObject, and mplement PFSubclassing protocol
class Post : PFObject, PFSubclassing {
    
    var image: Dynamic<UIImage?> = Dynamic(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    var likes =  Dynamic<[PFUser]?>(nil)    // dynamic, optional arry of PFUsers
    
    static var imageCache: NSCacheSwift<String, UIImage>!

    
    // 2 - Define each property you want to access in Parse class
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    
    //MARK: PFSubclassing Protocol
    
    // 3 -  Create a connection between Parse class and Swift class
    static func parseClassName() -> String {
        return "Post"
    }
    
    // 4 - Pure boilerplate code (Copy into any custom Parse class)
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
            // 1
            Post.imageCache = NSCacheSwift<String, UIImage>()
        }
    }
    
    func uploadPost() {
        let imageData = UIImageJPEGRepresentation(image.value, 0.8)
        let imageFile = PFFile(data: imageData)
        
        // 1
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        // 2
        imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            // 3
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        // any uploaded post should be associated with the current user
        user = PFUser.currentUser()
        self.imageFile = imageFile
        saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
    }
    
    func downloadImage() {
        // 1 - try to assign value from cache
        image.value = Post.imageCache[self.imageFile!.name]
        
        // if image is not downloaded yet, get it
        if (image.value == nil) {
            
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                
                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                }
                
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    self.image.value = image
                    // 2
                    Post.imageCache[self.imageFile!.name] = image
                }
            }
        }
    }
    
    func fetchLikes() {
        // 1
        if (likes.value != nil) {
            return
        }
        
        // 2 - fetch the likes of the current post
        ParseHelper.likesForPost(self, completionBlock: { (var likes: [AnyObject]?, error: NSError?) -> Void in
            
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            // 3 - remove any likes from users that have deleted their accounts
            likes = likes?.filter { like in like[ParseHelper.ParseLikeFromUser] != nil }
            
            // 4 - replace the likes in the array with users that are associated with each like
            self.likes.value = likes?.map { like in
                let like = like as! PFObject
                let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser
                
                return fromUser
            }
        })
    }
    
    func doesUserLikePost(user: PFUser) -> Bool {
        if let likes = likes.value {
            return contains(likes, user)
        } else {
            return false
        }
    }
    
    func toggleLikePost(user: PFUser) {
        if (doesUserLikePost(user)) {
            // if image is liked, unlike it now
            // 1 - remove the user from the local cache stored in the likes property, then sync change with Parse
            likes.value = likes.value?.filter { $0 != user }
            ParseHelper.unlikePost(user, post: self)
        } else {
            // if this image is not liked yet, like it now
            // 2 - add user to the local cache, then sync change with Parse
            likes.value?.append(user)
            ParseHelper.likePost(user, post: self)
        }
    }
    
}
