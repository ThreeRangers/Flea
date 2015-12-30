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
        
        
        setupSubclass()
        ParseInterface.sharedInstance.parseSetup()
        
        PFUser.enableAutomaticUser()
        let defaultACL = PFACL()
        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        
        
        // register subclass of parse so that it could be cast
        Market.registerSubclass()
        Shop.registerSubclass()
        
        
        // override select color of tabbard
        
        
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // Q_add for show Profile storyboard as root view
        //        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        //        let vc: ProfileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        // Q_add for show Login storyboard as root view SignInViewController
//        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//        let vc: SignInViewController = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
        
        // Q_add for show AddMarket storyboard as root view AddingMarketViewController
        let storyboard: UIStoryboard = UIStoryboard(name: "AddMarket", bundle: nil)
        let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("MarketNavigationControllerID") as! UINavigationController
        
        self.window?.rootViewController = vc
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        //FBSDKAppEvents.activateApp()
    }
    
    
    func setupSubclass() {
        Shop.registerSubclass()
    }
    
}


