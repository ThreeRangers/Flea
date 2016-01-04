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
    
    var image : UIImage?
    var imageGalary : [UIImage] = []
    
    @NSManaged var profileImg: PFFile
    @NSManaged var name: String?
    @NSManaged var facebookLink: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var descriptionText: String?
    @NSManaged var gallery: [PFFile]
    @NSManaged var likes: NSNumber?
    
    var market: PFRelation! {
        return relationForKey("marketpalce")
    }
    
    var finishCallback: ((shop: Shop) -> Void)?
    
    override init() {
        super.init()
    }
    
    init(shopData: NSDictionary) {
        super.init()
        
        self.name = shopData["name"] as? String
        self.facebookLink = shopData["link"] as? String
        self.phone = shopData["phone"] as? String
        self.descriptionText = shopData["description"] as? String
        self.email   = shopData["emails"]?[0] as? String
    }
    
    func uploadInfoDataWithImg() {
        if let file: PFFile = profileImg{
            file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded {
                    //                    self.saveData()
                    //2
                } else if let error = error {
                    //3
                    print("error uploading file",error)
                    return
                }
                }, progressBlock: { percent in
                    //4
                    print("Uploaded: \(percent)%")
            })
        }
        if gallery.count > 0 {
            for fileToUpload in gallery {
                fileToUpload.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    if succeeded {
                        //                    self.saveData()
                        //2
                    } else if let error = error {
                        //3
                        print("error uploading file",error)
                        return
                    }
                    }, progressBlock: { percent in
                        //4
                        print("Uploaded: \(percent)%")
                })
            }
        }
        self.saveData()
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
    
    // load image shop
    func loadImage(completion: () -> ()) {
        self.profileImg.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    print("get shop image from background")
                    
                    self.image = UIImage(data:imageData)
                    
                    //call back the completed function
                    completion()
                }
            }
        }
    }
    
    
    func loadGalary(completion: () -> ()) {
        if imageGalary.count > 0 {
            return
        }
        
        for imageFile in gallery {
            ParseClient.loadImage(imageFile, completion: { (data) -> () in
                self.imageGalary.append(UIImage(data:data!)!)
            })
        }
        completion()
    }
}

// MARK: Love
extension Shop {
    //love shop
    func love(enable: Bool, callback: PFBooleanResultBlock) {
        if let currentUser = User.currentUser() {
            if enable {
                print("Add object to loveshops list")
                currentUser.loveShops.addObject(self)
            } else {
                print("Remove object to loveshops list")
                currentUser.loveShops.removeObject(self)
            }
            currentUser.saveInBackgroundWithBlock(callback)
        }
    }
}
