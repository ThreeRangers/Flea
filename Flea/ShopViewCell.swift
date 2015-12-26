//
//  ShopViewCell.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import Foundation
import UIKit

let shopCellIdentify = "shopCellIdentify"

class ShopViewCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{
    var pullAction : ((offset : CGPoint) -> Void)?
    var tappedAction : (() -> Void)?
    
    var shop : Shop?
    let tableView = UITableView(frame: screenBounds, style: UITableViewStyle.Plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGrayColor()
        
        contentView.addSubview(tableView)
        tableView.registerClass(NTTableViewCell.self, forCellReuseIdentifier: cellIdentify)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this could be replace by facebook feed
        return 10
    }
    
    // init cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentify) as! NTTableViewCell!
        cell.imageView?.image = nil
        cell.textLabel?.text = nil
        if indexPath.row == 0 {
//            let image = UIImage(named: imageName!)
            
//            cell.imageView?.image = image
        }else{
            cell.textLabel?.text = "try pull to pop view controller 😃"
        }
        cell.setNeedsLayout()
        return cell
    }
    
    // set the height of cell
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var cellHeight : CGFloat = navigationHeight
        if indexPath.row == 0 {
//            let image:UIImage! = UIImage(named: imageName!)
//            let imageHeight = image.size.height*screenWidth/image.size.width
//            cellHeight = imageHeight
        }
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tappedAction?()
    }
    
    func scrollViewWillBeginDecelerating(scrollView : UIScrollView){
        if scrollView.contentOffset.y < navigationHeight{
            pullAction?(offset: scrollView.contentOffset)
        }
    }
}
