//
//  MarketViewController.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import MapKit
private let reuseMarketIdentifier = "MarketCell"


class MarketViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var markets = [Market]()
    var switchButton: DOFavoriteButton!
 
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var switchModeButton: DOFavoriteButton!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func switchModeAction(sender: DOFavoriteButton) {
    
        if sender.selected {
            sender.deselect()
            
            collectView.hidden = false
            mapView.hidden = true
        } else {
            // select with animation
            sender.select()
            
            collectView.hidden = true
            mapView.hidden = false
        }
    }

    func addLocation(market : Market) {
        if market.location == nil {
            return
        }
        
        let location = CLLocationCoordinate2D(
            latitude: (market.location?.latitude)!,
            longitude: market.location!.longitude
        )
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = market.name
        annotation.subtitle = market.desc
        
        mapView.addAnnotation(annotation)
    }
    func loadMapView() {
        if markets.count > 0 {
            for market in markets {
                self.addLocation(market)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Market.getAll { (data) -> () in
            self.markets = data
            self.collectView?.reloadData()
            self.loadMapView()
        }
        
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
       
        mapView.hidden = true
        collectView.dataSource = self
        collectView.delegate = self
        
        collectView!.backgroundColor = UIColor.clearColor()
        collectView!.decelerationRate = UIScrollViewDecelerationRateFast
        
        switchModeButton.addTarget(self, action: Selector("switchModeAction:"), forControlEvents: .AllEvents)
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
            let indexPath = collectView?.indexPathForCell(sender as! UICollectionViewCell)
            
        
            let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
            if let tabBar = appDelegate.window!.rootViewController as? RAMAnimatedTabBarController {
                
                let shopVC = tabBar.viewControllers![1] as! ShopViewController
                shopVC.market = self.markets[(indexPath?.row)!]
                shopVC.markets = self.markets
                
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

extension MarketViewController  {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return markets.count
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectView.dequeueReusableCellWithReuseIdentifier(reuseMarketIdentifier, forIndexPath: indexPath) as! MarketCell
        cell.market = self.markets[indexPath.item]
        
        if cell.market!.image == nil {
            cell.market!.loadImage { () -> () in
                self.collectView.reloadData()
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

