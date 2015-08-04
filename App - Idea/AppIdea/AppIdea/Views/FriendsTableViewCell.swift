//
//  FriendsTableViewCell.swift
//  AppIdea
//
//  Created by Ryan Vanderhoef on 7/23/15.
//  Copyright (c) 2015 Ryan Vanderhoef. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var friendsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
