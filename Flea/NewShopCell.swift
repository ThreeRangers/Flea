//
//  NewShopCell.swift
//  Flea
//
//  Created by Dat Nguyen on 30/12/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import AFNetworking

class NewShopCell: UITableViewCell {

    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var shop: Shop! {
        didSet {
            nameLabel.text = shop.name
            descriptionLabel.text = shop.description
            //shopImageView.setImageWithURL(NSURL(string: shop.profileImg.url!)!)
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
