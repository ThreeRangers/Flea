//
//  ResultViewController.swift
//  Flea
//
//  Created by Dat Nguyen on 4/1/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import UIKit

private let reuseIdentifier = "pageCell"

class ResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    var shops: [Shop] = []
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shopCollectionView.delegate = self
        shopCollectionView.dataSource = self
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return shops.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SearchCell
        
        // Configure the cell
        cell.shop = shops[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let collectionCell = cell as? SearchCell else { return }
        
        collectionCell.setTableViewDataSourceDelegate(self, forRow: indexPath.row)
        collectionCell.tableViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let collectionCell = cell as? SearchCell else { return }
        
        storedOffsets[indexPath.row] = collectionCell.tableViewOffset
    }

    
    @IBAction func onCloseTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let shop = shops[tableView.tag]
        
        switch indexPath.row {
        case 0:
            let phoneCell = tableView.dequeueReusableCellWithIdentifier("phoneCell", forIndexPath: indexPath) as! PhoneCell
            phoneCell.phoneLabel.text = shop.phone
            cell = phoneCell
            break
            
        case 1:
            let addressCell = tableView.dequeueReusableCellWithIdentifier("addressCell", forIndexPath: indexPath) as! AdressCell
            addressCell.addressLabel.text = shop.address
            cell = addressCell
            break
            
        case 2:
            let descCell = tableView.dequeueReusableCellWithIdentifier("descCell", forIndexPath: indexPath) as! DescCell
            descCell.descLabel.text = shop.descriptionText
            cell = descCell
            break
            
        default:
            cell = UITableViewCell()
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
