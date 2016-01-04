//
//  ProfileMarketViewController.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/28/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class ProfileMarketViewController: UIViewController {
    var markets = [Market]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMarkets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMarkets() {
        print("loading user's markets")
        if let currentUser = User.currentUser() {
            currentUser.getMarkets(NSDate(), callback: { (markets, error) -> Void in
                if let markets = markets {
                    self.markets = markets
                    self.tableView.reloadData()
                } else {
                    print(error)
                }
            })
        }
        
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

extension ProfileMarketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileMarketCell", forIndexPath: indexPath) as! ProfileMarketCell
        cell.market = markets[indexPath.row]
        if cell.market!.image == nil {
            cell.market!.loadImage { () -> () in
                self.tableView.reloadData()
            }
        }
        return cell
    }
}
