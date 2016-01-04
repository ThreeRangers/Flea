//
//  Extensions.swift
//  Flea
//
//  Created by Dat Nguyen on 2/1/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import UIKit
import SCLAlertView

class Extensions: NSObject {

}

extension UIViewController {
    func showDialog(title: String, msg: String, colorStyle: UInt) {
        //        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        //
        //        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        //
        //        self.presentViewController(alertController, animated: true, completion: nil)
        let alertView = SCLAlertView()
        
        alertView.showError(title, subTitle: msg, closeButtonTitle: "Dismiss", duration: 0.0, colorStyle: colorStyle, colorTextButton: 0xFFFFFF)
    }
    
    func saveDataWithKey(key: String, obj: AnyObject) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func isBlank() -> Bool {
        return self.trim().isEmpty
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
}