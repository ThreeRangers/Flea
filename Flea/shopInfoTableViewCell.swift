//
//  shopTableViewCell.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/21/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

let qTapImageNotificationKey = "q.tapNotificationkey"
//MARK: Implement delegate
//@objc protocol shopInfoTableViewCellDelegate {
//    optional func tapProfileImage(shopInfoTableViewCell: shopInfoTableViewCell, image: UIImage?)
//}
class shopInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shopProfileImgView: UIImageView!
    
    @IBOutlet weak var shopNameTextField: UITextField!
    
    @IBOutlet weak var faceLinkTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var save: UIButton!
    //    var delegate: shopInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      // shopProfileImgView.addSubview(save)
      //  shopProfileImgView.bringSubviewToFront(save)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTapProfileImg:"))
        tap.delegate = self
        shopProfileImgView.addGestureRecognizer(tap)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setInfo(completion: (edittingShop: Shop?, error: NSError?) -> ()) {
        let shop = Shop()
        shop.name = shopNameTextField.text
        shop.facebookLink = faceLinkTextField.text
        shop.phone = phoneTextField.text
        shop.email = emailTextField.text
        if let image = shopProfileImgView.image {
            let imageFile = PFFile(name: "shopProfileImg", data: UIImageJPEGRepresentation(image, 0.4)!)
            shop.profileImg = imageFile!
            print("PFFIle: ",shop.profileImg)
        }
        completion(edittingShop: shop, error: nil)
    }
    
    func handleTapProfileImg(sender: UITapGestureRecognizer? = nil) {
        print("tap Image")
        //        delegate?.tapProfileImage!(self, image: shopProfileImgView.image)
        NSNotificationCenter.defaultCenter().postNotificationName(qTapImageNotificationKey, object: self)
    }
    
}
