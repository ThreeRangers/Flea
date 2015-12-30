//
//  LogInViewController.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/19/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

//import UIKit
//import Parse
//import ParseUI
//
//class LogInViewController: UIViewController,PFLogInViewControllerDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        print("view Didappear")
//        performSegueWithIdentifier("shopSegue", sender: self)
//        super.viewDidAppear(animated)
//        let currentUser = PFUser.currentUser()?.username
//        if (currentUser == nil) {
//            let loginViewController = PFLogInViewController()
//            loginViewController.delegate = self
//            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .PasswordForgotten, .SignUpButton, .Facebook]
//            loginViewController.emailAsUsername = true
//            self.presentViewController(loginViewController, animated: false, completion: nil)
//        } else {
//            presentLoggedInAlert()
//        }
//    }
//    
//    func presentLoggedInAlert() {
//        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Flea", preferredStyle: .Alert)
//        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//        alertController.addAction(OKAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        presentLoggedInAlert()
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
