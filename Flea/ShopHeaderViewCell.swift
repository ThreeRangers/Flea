//
//  ShopHeaderViewCell.swift
//  Flea
//
//  Created by minh on 1/1/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import Foundation
import UIKit


@objc protocol shopHeaderDelegate {
    optional func nextMarket()
    optional func backMarket()
}


class ShopHeaderViewCell: UITableViewCell {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var LoveLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var reminderButton: DOFavoriteButton!
    @IBOutlet weak var loveButton: DOFavoriteButton!
    @IBOutlet weak var addShopButton: DOFavoriteButton!
    
    @IBOutlet weak var headerView: UIView!
    var delegate : shopHeaderDelegate?
    
    var market : Market? {
        didSet {
            if let market = market {
                
                print("init data for header")

                // load market info
                marketLabel.text = market.name
                
                var loveMarket = market.loves
                if loveMarket == nil {
                    loveMarket = 0
                }
                LoveLabel.text = String(loveMarket!)
                
                addressLabel.text = market.address == nil ? "" : market.address
                
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Day, .Hour, .Minute, .Second], fromDate: NSDate(), toDate: market.date_from!, options: [])
                dateFromLabel.text = String(components.day)
                
                
                // add tap button to image
                loveButton.addTarget(self, action: Selector("tappedLoveButton:"), forControlEvents: .TouchUpInside)
                
                addShopButton.addTarget(self, action: Selector("tappAddingShopButton:"), forControlEvents: .TouchUpInside)
                
                reminderButton.addTarget(self, action: Selector("remindButton:"), forControlEvents: .TouchUpInside)
            }
        }
    }
    
    func loadShop(shops : [Shop]) {

        self.shopLabel.text = String(shops.count)
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
            
            LoveLabel.text = String( Int(market!.loves!) - 1)
            
        } else {
            // select with animation
            sender.select()
            LoveLabel.text = String( Int(market!.loves!) + 1)
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
    
    
    @IBAction func nextMarketAction(sender: AnyObject) {
        print("trigger delegate next")
        delegate?.nextMarket!()
    }
    
    @IBAction func backMarketAction(sender: AnyObject) {
        print("trigger delegate next")
        delegate?.backMarket!()
    }
    
}
