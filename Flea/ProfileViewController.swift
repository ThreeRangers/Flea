//
//  ProfileViewController.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var switchViewSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var shopView: UIView!
    
    @IBOutlet weak var marketView: UIView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switchView()
    }
    func switchView() {
        switch switchViewSegmentControl.selectedSegmentIndex
        {
        case 0:
            marketView.hidden = false
            shopView.hidden = true
        case 1:
            marketView.hidden = true
            shopView.hidden = false
        default:
            break;
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var MarketsCntLabel: UILabel!
    
    @IBOutlet weak var wishListShopCntLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchView()
        //Load user data
        if let currentUser = User.currentUser()  {
            getUserInfor(currentUser)
            
        }
        
    }
    
    func getUserInfor(currentUser: PFUser) {
        //load profile Image
        if let imageFile = User.currentUser()!.objectForKey("profilePicture") as? PFFile {
            imageFile.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
                self.profileImgView.image = UIImage(data: data!)
            }
        } else {
            print("User has not profile picture")
        }
        
        //load other information
        self.nameLabel.text = currentUser.username
        self.phoneLabel.text = currentUser.objectForKey("phone") as? String
        self.emailLabel.text = currentUser.email
    }
}
