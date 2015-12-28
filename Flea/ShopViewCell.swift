//
//  ShopViewCell.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import Foundation
import UIKit
import DateTools

class ShopViewCell : UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var createLabel: UILabel!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var shop: Shop? {
        didSet {
            if let shop = shop {
                self.userImage.image = shop.image
                
                self.shopName.text = shop.name
                self.desc.text = shop.descriptionText
                self.likeButton.titleLabel!.text = String(shop.likes)
                
                self.createLabel.text = shop.updatedAt!.shortTimeAgoSinceNow()

            }
        }
    }
    
}
