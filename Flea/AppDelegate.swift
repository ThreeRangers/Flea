//
//  AppDelegate.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/17/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        ParseInterface.sharedInstance.parseSetup()
        
        PFUser.enableAutomaticUser()
        let defaultACL = PFACL()
        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        
        
        // register subclass of parse so that it could be cast
        Market.registerSubclass()
        Shop.registerSubclass()
        
        
        // override select color of tabbard
        UITabBar.appearance().tintColor = UIColor(red: 255/255.0, green: 187/255.0, blue: 0/255.0, alpha: 1.0)

        
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        return true
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
}

