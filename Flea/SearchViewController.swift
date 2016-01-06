//
//  NewShopViewController.swift
//  Flea
//
//  Created by Dat Nguyen on 30/12/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import SVPullToRefresh

var market: Market?

@objc protocol SearchViewControllerDelegate  {
    optional func updateShops()
}

class SearchViewController: UIViewController {

    @IBOutlet weak var shopTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var shopSearchBar: UISearchBar!
    
    var market: Market!
    
    var shops:[Shop] = []
    
    var after: String?
    
    var delegate : SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shopTableView.delegate = self
        shopTableView.dataSource = self
        shopSearchBar.delegate = self
        
        toggleEmptyLabel(true)
        
        //shopTableView.triggerPullToRefresh()
        
        //performSearch("nibi shop")
        
        shopTableView.addInfiniteScrollingWithActionHandler { () -> Void in
            self.performSearch(self.shopSearchBar.text!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) { () -> Void in
            self.delegate!.updateShops!()
        }
    }
    
    func performSearch(searchTerm: String) {
        
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        var params = [NSObject: AnyObject]()
        params["q"] = searchTerm
        params["type"] = "page"
        params["fields"] = "about,birthday,category,single_line_address,cover,description,emails,general_info,link,name,phone,username,picture"
        params["limit"] = 20
        
        if let isEmpty = after?.isBlank() {
            if !isEmpty { params["after"] = after }
        }
        
        let request = FBSDKGraphRequest.init(graphPath: "/search", parameters: params, tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler { (connection, result, error: NSError!) -> Void in
            
            guard error == nil else {
                self.showDialog("Error", msg: "\(error!.description)", colorStyle: 0xFD695C)
                return
            }
            
            if let paging = result["paging"]??["cursors"] as? NSDictionary {
                self.after = paging["after"] as? String
            }
            
            if let datas = result["data"] as? [NSDictionary] {
                
                for data in datas {
                    print("data", data)
                    self.shops.append(Shop(shopData: data))
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //print("shops", self.shops[0])
                self.shopTableView.reloadData()
                if self.shops.count > 0 {
                    self.performSegueWithIdentifier("resultSegue", sender: self)
                }
                self.toggleEmptyLabel(self.shops.isEmpty)
                self.shopTableView.infiniteScrollingView.stopAnimating()
            })
        }
    }
    
    func toggleEmptyLabel(isShow: Bool) {
        emptyLabel.hidden = !isShow
        shopTableView.hidden = isShow
        if shopSearchBar.text!.isBlank() {
            emptyLabel.text = "Please enter search above"
        } else {
            emptyLabel.text = "No results"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "resultSegue":
            
            let resultViewController = segue.destinationViewController as!  ResultViewController
            
            resultViewController.shops = shops
            resultViewController.market = market
            break
            
        default: break
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newShopCell") as! NewShopCell
        
        cell.shop = shops[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        resetResults()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isBlank() {
            resetResults()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        shops = []
        after = ""
        let searchText = searchBar.text!
        if searchText.isBlank() {
            resetResults()
            return
        }
        performSearch(searchText)
        print(searchText)
    }
    
    func resetResults() {
        shops = []
        shopTableView.reloadData()
        toggleEmptyLabel(true)
    }

}
