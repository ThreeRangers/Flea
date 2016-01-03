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
    
    @IBOutlet weak var imageConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var shopView: UIView!
    
    
    var shop: Shop? {
        didSet {
            if let shop = shop {
                self.userImage.image = shop.image
                
                self.shopName.text = shop.name
                self.desc.text = shop.descriptionText
                self.likeButton.titleLabel!.text = shop.likes == nil ? "10" : String(shop.likes!)
                
                // hide the collection view if the galllery is < 4, for the better layout
                if shop.gallery.count < 4 {
                    self.imageCollectionView.hidden = true
                    imageConstrain.constant = 8
                    // resize the frame
                    var frame = shopView.frame
                    frame.origin.y = 200
                    shopView.frame = frame
                }
                
                // set border conner and white
                self.userImage.clipsToBounds = true
                
                self.userImage.layer.cornerRadius = 3.0
                self.userImage.layer.borderColor = UIColor.whiteColor().CGColor;
                self.userImage.layer.borderWidth = 4.0;
                
                self.userImage.layer.shadowColor = UIColor.blackColor().CGColor;
                self.userImage.layer.shadowRadius = 2.0;
                self.userImage.layer.shadowOffset = CGSizeMake(0.0, 2.0);
                self.userImage.layer.shadowOpacity = 0.5;
                
                shopView.layer.cornerRadius = 3.0
                shopView.clipsToBounds = true
                
                /// self.createLabel.text = shop.updatedAt!.shortTimeAgoSinceNow()
            }
        }
    }
    
    
    @IBAction func onTapLoveButton(sender: AnyObject) {
        if let shop = shop {
            shop.love(true) { (successful: Bool, error: NSError?) -> Void in
                if successful {
                    print("loved")
              
                } else {
                    print("failed to love")
                  
                }
            }
        }
    }
  
}

extension ShopViewCell {
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        
        imageCollectionView.delegate = dataSourceDelegate
        imageCollectionView.dataSource = dataSourceDelegate
        imageCollectionView.tag = row
        imageCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set {
            imageCollectionView.contentOffset.x = newValue
        }
        
        get {
            return imageCollectionView.contentOffset.x
        }
    }
}
