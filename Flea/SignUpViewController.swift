//
//  SignUpViewController.swift
//  Flea
//
//  Created by Dat Nguyen on 23/12/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypedPasswordTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDismissTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSingUpTapped(sender: UIButton) {
        let username = self.emailTextField.text!.trim() as String
        let password = self.passwordTextField.text!.trim() as String
        let retypePassword = self.retypedPasswordTextField.text!.trim() as String
        let firstName = self.firstNameTextField.text!.trim() as String
        let lastName = self.lastNameTextField.text!.trim() as String
        
        var isError: Bool = false
        var mErr: String = ""
        
        if username.isBlank() || password.isBlank() || retypePassword.isBlank() {
            isError = true
            mErr = mErr + "Missing email or password\n"
        } else {
            if username.characters.count < 5 {
                isError = true
                mErr = mErr + "Email must be greater than 5 characters\n"
            }
            
            if password.characters.count < 8 {
                isError = true
                mErr = mErr + "Password must be greater than 8 characters\n"
            }
            
            if retypePassword != password {
                isError = true
                mErr = mErr + "Password does not match\n"
            }
        }
        
        if isError {
            showDialog("Error", msg: mErr, colorStyle: 0xFDBF61)
            return
        }
        
        let newUser = PFUser()
        
        newUser.username = username
        newUser.password = password
        newUser.email = username
        newUser["firstname"] = firstName
        newUser["lastname"] = lastName
        
        // Sign up the user asynchronously
        newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            guard error == nil else {
                if let signUpError = ParseError.ErrorDictionary[error!.code] {
                    self.showDialog("Error", msg: "\(signUpError)", colorStyle: 0xFDBF61)
                } else {
                    self.showDialog("Error", msg: ParseError.ErrorDictionary[99999]!, colorStyle: 0xFDBF61)
                }
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print("succeed", PFUser.currentUser())
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
