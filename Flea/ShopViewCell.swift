//
//  ShopViewCell.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import Foundation
import UIKit

class ShopViewCell : UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var createLabel: UILabel!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var shop: Shop? {
        didSet {
//            if let shop = shop {
//                self.marketLabel.text = market.name!
//                self.marketImage.image = market.image
//                self.locationLabel.text = market.address
//                let dateFormatter = NSDateFormatter()
//                dateFormatter.dateFormat = "dd/MM h:mm"
//                self.startDateLabel.text = dateFormatter.stringFromDate(market.date_from!)
//            }
        }
    }
    
}
