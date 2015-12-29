//
//  ShopViewController.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var market: Market!
    var shops : [Shop] = []
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var visitLabel: UILabel!
    @IBOutlet weak var LoveLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    
    @IBOutlet weak var reminderButton: DOFavoriteButton!
    @IBOutlet weak var loveButton: DOFavoriteButton!
    @IBOutlet weak var addShopButton: DOFavoriteButton!
    @IBOutlet weak var marketImage: UIImageView!
    
    func loadData() {
        // load market info
        marketLabel.text = market.name
        
        marketImage.image = market.image
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = marketImage.bounds
    
        // TODO: reafactore, just one view!!!
        marketImage.addSubview(blurView)
        
        
        // load shop by the current select market
        market.loadShops { (data) -> () in
            print("total shop \(data.count) of \(self.market)")
            
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
        } else {
            // select with animation
            sender.select()
            
            
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

extension ShopViewController {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ShopViewCell = tableView.dequeueReusableCellWithIdentifier("shopViewCell", forIndexPath: indexPath) as! ShopViewCell
        
        cell.shop = self.shops[indexPath.row]
        // load image for shop ?
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        // show the shop detail by listing facebook list
    }
}
