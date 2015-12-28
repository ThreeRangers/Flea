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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if market == nil {
            return
        }
        
        // load shop by the current select market
        market.loadShops { (data) -> () in
            print("total shop \(data.count) of \(self.market)")
            
            self.shops = data
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
