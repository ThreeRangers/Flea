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

                        result.append( Market(object: object))
                        
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
}