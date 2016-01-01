//
//  ShopViewController.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import DateTools
import MapKit


var headViewCellID = "shopHeaderViewCell"
class ShopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var marketImage: UIImageView!
    var headerCell : ShopHeaderViewCell!
    
    static let mapHeight = CGFloat(300.0)
    
    var market: Market!
    var shops : [Shop] = []
    var storedOffsets = [Int: CGFloat]()
    
    func loadShopImages() {
        // also load shop image
        for shop in self.shops {
            if shop.image == nil {
                shop.loadImage { () -> () in
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadData() {
        marketImage.image = market.image
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = marketImage.bounds
    
        for blurView in marketImage.subviews {
            blurView.removeFromSuperview()
        }
        marketImage.addSubview(blurView)
    
        self.shops = []
        self.tableView.reloadData()
        
        // load shop by the current select market
        market.loadShops { (data) -> () in
            self.shops = data
            
            self.loadShopImages()
            
            self.tableView.reloadData()
        }

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if market == nil {
            return
        }
        
        loadData()
        
        // Set the table views header cell and delegate
        let tableHeaderViewHeight:CGFloat = ShopViewController.mapHeight
        let mapView = MKMapView(frame: CGRectMake(0,0, self.view.frame.width, tableHeaderViewHeight))
        let tableHeaderView = ParallaxTableHeaderView(size: CGSizeMake(self.view.frame.width, tableHeaderViewHeight), subView: mapView)
        tableView.tableHeaderView = tableHeaderView
        
    
        tableView.delegate = self
        tableView.dataSource = self
        
        self.headerCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ShopHeaderViewCell
        
    }
    
   
    func updateHeaderBackground(hasColor : Bool) {
        let cell = self.headerCell
        
        guard cell == nil else {
            print("update the cell header") 
            if hasColor {
                cell.headerView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
            } else {
                cell.headerView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0)
            }
            tableView.reloadData()

            return
        }
    }
    
    /**
     Layout header content when table view scrolls
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxTableHeaderView = self.tableView.tableHeaderView as! ParallaxTableHeaderView
        
        header.layoutForContentOffset(tableView.contentOffset)
        
        // update background of header and animate
        self.updateHeaderBackground(tableView.contentOffset.y >= ShopViewController.mapHeight)
        
        self.tableView.tableHeaderView = header
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addShopSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let addingShopVC = navController.topViewController as! AddingShopViewController
            
            addingShopVC.market = self.market
        }
    }

}
extension ShopViewController : AddingShopViewControllerDelegate {
    // call back function from shop view to update shop list
    func updateMarket() {
        loadData()
    }
}

extension ShopViewController : UITableViewDataSource, UITableViewDelegate {
    // table header
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(headViewCellID) as! ShopHeaderViewCell
     
        cell.market = self.market
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 114.0
    }
    // number row on section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ShopViewCell = tableView.dequeueReusableCellWithIdentifier("shopViewCell", forIndexPath: indexPath) as! ShopViewCell
        
        cell.shop = self.shops[indexPath.row]
        
  
        // load galary image for shop
        cell.shop?.loadGalary({ () -> () in
            tableView.reloadData()
        })
        
        
        // for collection view
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        // show the shop detail by listing facebook list
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? ShopViewCell else {
            return
        }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return self.shops[collectionView.tag].gallery.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell : ShopGalleryViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("cellImageShopView",
                forIndexPath: indexPath) as? ShopGalleryViewCell)!
            
            let shop = self.shops[collectionView.tag]
            
            if indexPath.item >= shop.imageGalary.count {
                return cell
            }
            
            let shopImage : UIImage = shop.imageGalary[indexPath.item] 
            cell.shopImage.image = shopImage
            
            return cell
    }
}
