//
//  FeedViewController.swift
//  Flea
//
//  Created by Dat Nguyen on 4/1/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import UIKit
import SVPullToRefresh

class FeedViewController: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    var feeds: [Feed] = []
    var shop: Shop!
    
    var after: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        //after = "172715606249414_461962963991342"
        
        if let facebookID = shop.facebookID {
            loadFeeds(facebookID)
        } else {
            showDialog("Invalid", msg: "This shop does not associate with any facebook account", colorStyle: 0xFD695C)
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        feedTableView.addInfiniteScrollingWithActionHandler { () -> Void in
            self.loadFeeds(self.shop.facebookID!)
        }
        
        navigationController?.navigationBar.barTintColor = MyColor.Colors.RedPrimary
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadFeeds(id: String) {
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        var params = [NSObject: AnyObject]()
        params["fields"] = "id,caption,created_time,description,link,message,name,picture,place"
        params["limit"] = 20
        
        if let isEmpty = after?.isBlank() {
            if !isEmpty { params["after"] = after }
        }
        
        let request = FBSDKGraphRequest.init(graphPath: "/\(id)/posts", parameters: params, tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler { (connection, result, error: NSError!) -> Void in
            guard error == nil else {
                print("error", error)
                return
            }
            
            if let datas = result["data"] as? [NSDictionary] {
                
                for data in datas {
                    print("data", data)
                    self.feeds.append(Feed(feedData: data))
                    self.feedTableView.infiniteScrollingView.stopAnimating()
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //print("shops", self.shops[0])
                self.feedTableView.reloadData()
            })
            
            print("result", result)
        }
        
    }
    
    @IBAction func onCloseTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell") as! FeedCell
        
        cell.feed = feeds[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
}
