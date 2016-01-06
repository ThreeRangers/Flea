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
    
    @IBOutlet weak var notificationView: UIView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switchView()
    }
    func switchView() {
        switch switchViewSegmentControl.selectedSegmentIndex
        {
        case 0:
            marketView.hidden = false
            shopView.hidden = true
            notificationView.hidden = true
        case 1:
            shopView.hidden = false
            marketView.hidden = true
            notificationView.hidden = true
        case 2:
            notificationView.hidden = false
            shopView.hidden = true
            marketView.hidden = true
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
    
    let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load user data
        if let currentUser = User.currentUser()  {
            if currentUser.username == nil {
                let vc = loginStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
                
                presentViewController(vc, animated: true, completion: nil)
            }
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let currentUser = User.currentUser()  {
            if currentUser.username != nil {
                getUserInfor(currentUser)
                switchView()
            }
            
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
        self.nameLabel.text = currentUser.objectForKey("firstname") as? String
        self.phoneLabel.text = currentUser.objectForKey("phone") as? String
        self.emailLabel.text = currentUser.email
    }

}
