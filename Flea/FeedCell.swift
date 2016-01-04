//
//  FeedCell.swift
//  Flea
//
//  Created by Dat Nguyen on 4/1/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import UIKit
import AFNetworking

class FeedCell: UITableViewCell {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    var feed: Feed! {
        didSet {
            messageLabel.text = feed.message
            if let location = feed.location {
                locationLabel.text = location
            }
            
            createdAtLabel.text = feed.createdAt
            
            if let imageUrl = feed.imageUrl {
                pictureImageView.setImageWithURL(NSURL(string: imageUrl)!)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
