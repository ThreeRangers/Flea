//
//  SignInViewController.swift
//  Flea
//
//  Created by Dat Nguyen on 21/12/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import ParseUI
import SCLAlertView
import Parse
import ParseFacebookUtilsV4

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate, PFSignUpViewControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
        } else {
            fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
            fbLoginButton.delegate = self
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onLoginButtonTapped(sender: UIButton) {
        let username = self.emailTextField.text!.trim() as String
        let password = self.passwordTextField.text!.trim() as String
        
        // Validate the text fields
        if username.characters.count == 0 || password.characters.count == 0{
            showDialog("Error", msg: "Missing username or password", colorStyle: 0xFD695C)
        } else {
            // Run a loading to show a task in progress
            
            
            // Send a request to login
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                guard error == nil else {
                    if let signInError = ParseError.ErrorDictionary[error!.code] {
                        self.showDialog("Error", msg: "\(signInError)", colorStyle: 0xFD695C)
                    } else {
                        self.showDialog("Error", msg: ParseError.ErrorDictionary[99999]!, colorStyle: 0xFD695C)
                    }
                    
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                    //                        self.presentViewController(viewController, animated: true, completion: nil)
                    print("Login success", user)
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        }
    }
    
    @IBAction func onSignUpButtonTapped(sender: UIButton) {
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                // Do work
            }
            
            print(result)
            
            let accessToken = FBSDKAccessToken.currentAccessToken()
            
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email,name,id"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
                guard error == nil else {
                    print("\(error)")
                    return
                }
                
                print (result)
                
                PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken, block: { (user: PFUser?, error: NSError?) -> Void in
                    guard error == nil else {
                        self.showDialog("Error", msg: "\(error!)", colorStyle: 0xFD695C)
                        return
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        print("user", User.currentUser())
                        User.currentUser()!["firstname"] = result["name"]
                        User.currentUser()!["email"] = result["email"]
                        User.currentUser()!["lastname"] = ""
                        
                        if let userId = result["id"] as? String {
                            let profileURL: String = "https://graph.facebook.com/\(userId)/picture?type=large"
                            User.currentUser()!["profilePicture"] = profileURL
                        }
                        
                        //FBSDKLoginManager().logOut()
                        
                        print("user", User.currentUser())
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            })
            
            
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
        PFUser.logOut()
    }
    
    @IBAction func onTapOutside(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}
