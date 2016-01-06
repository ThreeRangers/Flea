//
//  MyColor.swift
//  Tripper
//
//  Created by Sinh Quyen Ngo on 12/9/15.
//  Copyright © 2015 ThreeRangers. All rights reserved.
//
// Revision History

import UIKit

class MyColor: UIColor {
    struct Colors {
        static let BluePrimary = UIColor(netHex: 0x12A5F4)
        static let BlueSecondary = UIColor(red: 212, green: 241, blue: 252)
        // color use for notification
        static let OrangePrimary = UIColor(red: 247, green: 120, blue: 9)
        static let OrangeSecondary = UIColor(red: 250, green: 101, blue: 19)
        static let GreenPrimary = UIColor(red: 110, green: 176, blue: 7)
        static let Gray = UIColor(red: 237, green: 241, blue: 247)
        //87 88 89
        static let GraySecondary = UIColor(red: 87, green: 88, blue: 89)
        
        static let RedPrimary = UIColor(red: 253, green: 105, blue: 92)
     }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    func toHex() -> UInt {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return UInt(String(format:"#%06x", rgb))!
    }
}