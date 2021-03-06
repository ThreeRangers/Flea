//
//  Shop.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/25/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import Foundation
import Parse

class Shop: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Shops"
    }
    
    @NSManaged var profileImg: PFFile
    @NSManaged var name: String?
    @NSManaged var facebookLink: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var descriptionText: String?
    @NSManaged var gallery: [PFFile]
    
    var finishCallback: ((shop: Shop) -> Void)?
    
    func uploadInfoDataWithImg() {
        if let file: PFFile = profileImg{
            file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded {
                    self.saveData()
                    //2
                } else if let error = error {
                    //3
                    print("error uploading file",error)
                }
                }, progressBlock: { percent in
                    //4
                    print("Uploaded: \(percent)%")
            })
        }
    }
    func saveData() {
        saveInBackgroundWithBlock({ (success, error) -> Void in
            guard error == nil else {
                print(error)
                return
            }
            self.finishCallback?(shop: self)
        })
    }
}
