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
        
        // get permission access on map view
        let locationManager: CLLocationManager! = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        setupSubclass()
        ParseInterface.sharedInstance.parseSetup()
        
        PFUser.enableAutomaticUser()
        let defaultACL = PFACL()
        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        
        // override select color of tabbard
    
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // Q_add for show Add market view as root view
//        let storyboard = UIStoryboard(name: "AddMarket", bundle: nil)
//        let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("MarketNavigationControllerID") as! UINavigationController
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc: ProfileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewControllerID") as! ProfileViewController

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
        // register subclass of parse so that it could be cast
        Market.registerSubclass()
        Shop.registerSubclass()
        User.registerSubclass()
    }
    
}

