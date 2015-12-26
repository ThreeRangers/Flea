//
//  MarketViewController.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

private let reuseMarketIdentifier = "MarketCell"


import UIKit

class MarketViewController: UICollectionViewController {
    
    var markets = [Market]()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Market.getAll { (data) -> () in
            self.markets = data
            self.collectionView?.reloadData()
        }
        
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
}

extension MarketViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return markets.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseMarketIdentifier, forIndexPath: indexPath) as! MarketCell
        cell.market = self.markets[indexPath.item]
        
        print("--load image view cell")
        if cell.market!.image == nil {
            cell.market!.loadImage { () -> () in
                collectionView.reloadData()
            }
        }
    
        return cell
    }
    
}
