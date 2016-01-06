//
//  SearchCell.swift
//  Flea
//
//  Created by Dat Nguyen on 3/1/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import UIKit
import AFNetworking

class SearchCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    
    var market: Market!
    
    var shop: Shop! {
        didSet {
            nameLabel.text = shop.name
            if let profile = shop.profileImageUrl {
                profileImageView.setImageWithURL(NSURL(string: profile)!)
            }
            
            if let cover = shop.coverUrl {
                coverImageView.setImageWithURL(NSURL(string: cover)!)
            } else {
                coverImageView.image = nil
            }
        }
    }
    
    @IBAction func onAddButtonTapped(sender: UIButton) {
        print("shop", shop)
        let marketRelation = shop.relationForKey("market")
        marketRelation.addObject(self.market)
        shop.saveData()
        
    }
}

extension SearchCell {
    func setTableViewDataSourceDelegate<D: protocol<UITableViewDataSource, UITableViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        
        infoTableView.delegate = dataSourceDelegate
        infoTableView.dataSource = dataSourceDelegate
        infoTableView.tag = row
        infoTableView.reloadData()
    }
    
    var tableViewOffset: CGFloat {
        set {
            infoTableView.contentOffset.x = newValue
        }
        
        get {
            return infoTableView.contentOffset.x
        }
    }
}