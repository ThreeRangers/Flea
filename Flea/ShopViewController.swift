//
//  ShopViewController.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import DateTools


class ShopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var market: Market!
    var shops : [Shop] = []
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var LoveLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var dateFromLabel: UILabel!
    
    
    @IBOutlet weak var reminderButton: DOFavoriteButton!
    @IBOutlet weak var loveButton: DOFavoriteButton!
    @IBOutlet weak var addShopButton: DOFavoriteButton!
    @IBOutlet weak var marketImage: UIImageView!
    
    var storedOffsets = [Int: CGFloat]()
    
    
    func loadData() {
        // load market info
        marketLabel.text = market.name
        LoveLabel.text = String(market.loves!)
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Hour, .Minute, .Second], fromDate: NSDate(), toDate: market.date_from!, options: [])
        dateFromLabel.text = String(components.day)
        
        
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
            self.shopLabel.text = String(data.count)
            self.tableView.reloadData()
        }
        
        // add tap button to image
        loveButton.addTarget(self, action: Selector("tappedLoveButton:"), forControlEvents: .TouchUpInside)
        addShopButton.addTarget(self, action: Selector("tappAddingShopButton:"), forControlEvents: .TouchUpInside)
        reminderButton.addTarget(self, action: Selector("remindButton:"), forControlEvents: .TouchUpInside)
    }
   
    func remindButton(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()

        }
    }

    func tappedLoveButton(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()

            LoveLabel.text = String( Int(market.loves!) - 1)

        } else {
            // select with animation
            sender.select()
            LoveLabel.text = String( Int(market.loves!) + 1)
        }
    }
    
    func tappAddingShopButton(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if market == nil {
            return
        }
        
        loadData()
    
        tableView.delegate = self
        tableView.dataSource = self
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ShopViewCell = tableView.dequeueReusableCellWithIdentifier("shopViewCell", forIndexPath: indexPath) as! ShopViewCell
        
        cell.shop = self.shops[indexPath.row]
        
        // load image
        if cell.shop!.image == nil {
            cell.shop!.loadImage { () -> () in
                tableView.reloadData()
            }
        }
        
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
            
            let shopImage : UIImage = shop.imageGalary[indexPath.item] 
            cell.shopImage.image = shopImage
            
            return cell
    }
}
