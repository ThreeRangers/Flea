//
//  ParseInterface.swift
//  Flea
//
//  Created by MAC on 12/19/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import Parse

class ParseInterface: NSObject {
    
    let appId = "5bHoTl4zaxjxd3W2yInkpvA6qwxOMwv83PPHPlgE"
    let clientKey = "4dUz8BLHSipyzUVMnLTvMBaLw7rHGf3xCzBbEOEp"
    
//    let appId = "UrI6mw9BZBe1pZivCeP5hr9m86eEberAHKUy6PHJ"
//    let clientKey = "FkbKKZ8neqVBQhGVBSrUOcKT4LKvrMW0fWnlOn2Y"
    
    var signUpIsSuccess = false
    var loginIsSuccess = false
    // sharedInstance to be used in other classes
    
    class var sharedInstance: ParseInterface {
        struct Static {
            static var instance = ParseInterface()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
    }
    
    // This will be call in AppDelegate to setup Parse Application
    
    func parseSetup() {
        Parse.setApplicationId(appId, clientKey: clientKey)
    }
}  // End of Class

