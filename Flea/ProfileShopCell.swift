//
//  ProfileShopCell.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/29/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class ProfileShopCell: UITableViewCell {
    
    
    @IBOutlet weak var profileShopImgView: UIImageView!
    
    @IBOutlet weak var shopNameLanbel: UILabel!
    
    @IBOutlet weak var shopEmailLabel: UILabel!
    
    @IBOutlet weak var shopPhoneLabel: UILabel!
    
    var shop: Shop? {
        didSet {
            if let shop = shop {
                self.profileShopImgView.image = shop.image
                self.shopNameLanbel.text = shop.name
                self.shopEmailLabel.text = shop.email
                self.shopPhoneLabel.text = shop.phone
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileShopImgView.layer.cornerRadius = 8.0
        profileShopImgView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
