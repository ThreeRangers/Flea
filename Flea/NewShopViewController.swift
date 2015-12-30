//
//  NewShopViewController.swift
//  Flea
//
//  Created by Dat Nguyen on 30/12/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit


class NewShopViewController: UIViewController {

    @IBOutlet weak var shopTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var shops:[Shop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toggleEmptyLabel(true)
        
        performSearch("nibi shop")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performSearch(searchTerm: String) {
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        let request = FBSDKGraphRequest.init(graphPath: "/search", parameters: ["q":searchTerm, "type":"page"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler { (connection, result, error: NSError!) -> Void in
            
            guard error == nil else {
                self.showDialog("Error", msg: "\(error!.description)", colorStyle: 0xFD695C)
                return
            }
            
            if let datas = result["data"] as? [NSDictionary] {
                for data in datas {
                    //print("shop", shop["id"]!)
                    let pageRequest = FBSDKGraphRequest.init(graphPath: "/\(data["id"]!)", parameters: ["fields":"about,birthday,category,single_line_address,cover,description,emails,general_info,link,name,phone,username"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
                    pageRequest.startWithCompletionHandler({ (connection, result, error:NSError!) -> Void in
                        guard error == nil else {
                            self.showDialog("Error", msg: "\(error!.description)", colorStyle: 0xFD695C)
                            return
                        }
                        
                        self.shops.append(Shop(shopData: result as! NSDictionary))
                        
                    })
                }
            }
        }
        
        toggleEmptyLabel(shops.isEmpty)
    }
    
    func toggleEmptyLabel(isShow: Bool) {
        emptyLabel.hidden = !isShow
        shopTableView.hidden = isShow
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

extension NewShopViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newShopCell") as! NewShopCell
        
        cell.shop = shops[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
}
