//
//  Feed.swift
//  Flea
//
//  Created by Dat Nguyen on 4/1/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import UIKit
import DateTools

class Feed: NSObject {
    var message: String?
    var createdAt: String?
    var imageUrl: String?
    var location: String?
    var link: String?
    
    init(feedData: NSDictionary) {
        self.message = feedData["message"] as? String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
        dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        
        let defaultFormatter = NSDateFormatter()
        defaultFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        let dt = dateFormatter.dateFromString(feedData["created_time"] as! String)
        
        self.createdAt = dt?.timeSinceNow(defaultFormatter)
        print(createdAt)
        self.imageUrl = feedData["picture"] as? String
        self.link = feedData["link"] as? String
        self.location = feedData["place"]?["name"] as? String
    }
    
    
}
