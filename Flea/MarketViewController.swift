//
//  MarketViewController.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
private let reuseMarketIdentifier = "MarketCell"


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
        print("perform segue 1")
        
        if segue.identifier  == "openShopSegue" {
            // get current select row
            let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            
        
            let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
            if let tabBar = appDelegate.window!.rootViewController as? RAMAnimatedTabBarController {
                
                let shopVC = tabBar.viewControllers![1] as! ShopViewController
                shopVC.market = self.markets[(indexPath?.row)!]
                tabBar.setSelectIndex(from: 0, to: 1)
            }
// question: not work on this tabBar ?
//            let tabBar = segue.destinationViewController as! RAMAnimatedTabBarController
//            let shopVC = tabBar.viewControllers![1] as! ShopViewController
//            shopVC.market = self.markets[(indexPath?.row)!]
            
            
//            self.presentViewController(shopVC, animated: true, completion: nil)
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

extension MarketViewController : UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)  {
//            let select = item
    }
}