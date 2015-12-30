//
//  User.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/27/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import Parse
import Foundation

typealias MarketResultBlock = (markets: [Market]?, error: NSError?) -> Void
typealias ShopResultBlock = (shops: [Shop]?, error: NSError?) -> Void
class User: PFUser {
    @NSManaged var profileImg: PFFile?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var role: PFRole
    
    var markets: PFRelation! {
        return relationForKey("marketplace")
    }
    
    var shops: PFRelation! {
        return relationForKey("shop")
    }
    
    func getMarkets(lastUpdated:NSDate?, callback: MarketResultBlock) {
        if let query = Market.query() {
            // defines query
            query.findObjectsInBackgroundWithBlock({ (pfObj: [PFObject]?, error: NSError?) -> Void in
                guard error == nil else {
                    callback(markets: nil, error: error)
                    return
                }
                if let markets = pfObj as? [Market] {
                    callback(markets: markets, error: nil)
                }
            })
        }
    }
    
    func getShops(lastUpdated:NSDate?, callback: ShopResultBlock) {
        if let query = Market.query() {
            // defines query
            query.findObjectsInBackgroundWithBlock({ (pfObj: [PFObject]?, error: NSError?) -> Void in
                guard error == nil else {
                    callback(shops: nil, error: error)
                    return
                }
                if let shops = pfObj as? [Shop] {
                    callback(shops: shops, error: nil)
                }
            })
        }
    }
}
