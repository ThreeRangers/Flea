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
    
    func updateTabbarShop() {
        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        if let tabBarController = appDelegate.window!.rootViewController as? RAMAnimatedTabBarController {
            tabBarController.setSelectIndex(from: 0, to: 1)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier  == "openShopSegue" {
            // transfer data to 2nd view
            let shopVC = segue.destinationViewController as! ShopViewController
            let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            shopVC.market = self.markets[indexPath!.row]
            
            print("get this market \(shopVC.market)")
            updateTabbarShop()
        }
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
        
        if cell.market!.image == nil {
            cell.market!.loadImage { () -> () in
                collectionView.reloadData()
            }
        }
    
        return cell
    }
}
