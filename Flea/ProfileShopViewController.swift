//
//  ProfileShopViewController.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/28/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class ProfileShopViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var shops = [Shop]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadShops()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadShops() {
        print("loading user's love shops")
        if let currentUser = User.currentUser() {
            currentUser.getLoveShops(NSDate(), callback: { (shops, error) -> Void in
                if let shops = shops {
                    self.shops = shops
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
extension ProfileShopViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileShopCell", forIndexPath: indexPath) as! ProfileShopCell
        cell.shop = shops[indexPath.row]
        if cell.shop!.image == nil {
            cell.shop!.loadImage { () -> () in
                self.tableView.reloadData()
            }
        }
        return cell
    }
    
}
