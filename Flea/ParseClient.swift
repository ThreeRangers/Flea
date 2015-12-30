//
//  ParseClient.swift
//  Flea
//
//  Created by minh on 12/25/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import Foundation
import Parse

class ParseClient: NSObject {

    // load all market
    static func getAllMaket( completion:(data: [Market]) -> ()  )  {
        var result = [Market]()
        
        let query = PFQuery(className:"marketplace")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) market")
                
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {

                        result.append(object as! Market)
                        print(object)
                        
                        // call back function
                        completion(data: result)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // load shop by the market
    static func getVendorShops( market: Market, completion:(data: [Shop]) -> () ) {
        var result = [Shop]()
        
        let query = PFQuery(className:"Shops")
        query.whereKey("market", equalTo: market)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Successfully retrieved \(objects!.count) shops")
                if let objects = objects {
                    for object in objects {
                        
                        result.append(object as! Shop)
                        
                        // call back function
                        completion(data: result)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    static func loadImage(imageFile : PFFile, completion: (NSData?) -> ()) {
        imageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    completion(imageData)
                }
            }
        }
    }
}