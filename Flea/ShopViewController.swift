//
//  ShopViewController.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit
import DateTools
import MapKit
import SCLAlertView

var headViewCellID = "shopHeaderViewCell"
class ShopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var marketImage: UIImageView!
    var headerCell : ShopHeaderViewCell!
    
    var mapHeight = CGFloat(360.0)
    
    var market: Market!
    var markets: [Market] = []
    var mapView = MKMapView()
    var annotationMapping = [MKPointAnnotation]()
    
    var shops : [Shop] = []
    var storedOffsets = [Int: CGFloat]()
    var currentHasColor = false
    
    func loadShopImages() {
        // also load shop images
        
        for shop in self.shops {
            if shop.image == nil {
                shop.loadImage { () -> () in
                    self.tableView.reloadData()
                }
                shop.loadGalary({ () -> () in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func loadData() {
        marketImage.image = market.image
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = marketImage.bounds
    
        for blurView in marketImage.subviews {
            blurView.removeFromSuperview()
        }
        marketImage.addSubview(blurView)
    
        self.shops = []
        self.tableView.reloadData()
        
        // load shop by the current select market
        market.loadShops { (data) -> () in
            self.shops = data
            
            self.loadShopImages()
            
            self.getHeaderCell()
            
            self.headerCell.loadShop(self.shops)
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if market == nil {
            return
        }
        
        loadData()
        
        loadMapView()
    }
    
    func getCellHeader() -> ShopHeaderViewCell{
        if self.headerCell == nil {
            self.headerCell = self.tableView.dequeueReusableCellWithIdentifier(headViewCellID) as! ShopHeaderViewCell
        }
        return self.headerCell
    }
    
    /**
     Layout header content when table view scrolls
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxTableHeaderView = self.tableView.tableHeaderView as! ParallaxTableHeaderView
        
        header.layoutForContentOffset(tableView.contentOffset)
        
        updateHeaderBackground()
        
        self.tableView.tableHeaderView = header
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideHeaderAnimate()
        
        self.mapHeight = self.view.frame.height - 140.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addShopSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let addingShopVC = navController.topViewController as! AddingShopViewController
            
            addingShopVC.delegate = self
            addingShopVC.market = self.market
        
        }
        
        if segue.identifier == "searchSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let searchViewController = navController.topViewController as! SearchViewController
            
            searchViewController.delegate = self
            searchViewController.market = self.market
            
        }
        
        if segue.identifier == "feedSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.viewControllers.first   as! FeedViewController
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            
            vc.shop = shops[indexPath.row]
        }
    }
    
    @IBAction func onAddTapped(sender: DOFavoriteButton) {
        let alertView = SCLAlertView()
        alertView.addButton("New Shop") { () -> Void in
            self.performSegueWithIdentifier("addShopSegue", sender: self)
        }
        
        alertView.addButton("From Facebook") { () -> Void in
            self.performSegueWithIdentifier("searchSegue", sender: self)
        }
        
        alertView.showNotice("Add New Shop", subTitle: "Add new shop or import from Facebook")
    }
    
}


extension ShopViewController : MKMapViewDelegate {
    func loadMapView() {
        // Set the table views header cell and delegate
        let tableHeaderViewHeight:CGFloat = self.mapHeight
        self.mapView = MKMapView(frame: CGRectMake(0,0, self.view.frame.width, tableHeaderViewHeight))
        
        self.annotationMapping.removeAll()
        
        if markets.count > 0 {
            for marketItem in markets {
                if market.location == nil {
                    continue
                }
                
                let annotation : MKPointAnnotation = self.addLocation(marketItem, mapView: mapView)
                
                self.annotationMapping.append(annotation)
                
                if (self.market == marketItem) {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        let tableHeaderView = ParallaxTableHeaderView(size: CGSizeMake(self.view.frame.width, tableHeaderViewHeight), subView: mapView)
        tableView.tableHeaderView = tableHeaderView
    }
    
    func addLocation(market : Market, mapView : MKMapView) -> MKPointAnnotation{
        let location = CLLocationCoordinate2D(
            latitude: (market.location?.latitude)!,
            longitude: market.location!.longitude
        )
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = market.name
        annotation.subtitle = market.desc
        
        mapView.addAnnotation(annotation)
        
        return annotation
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        print("Selected annotation")
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
        
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.image = UIImage(named:"vendor-active")!
                
            }
            else {
                pinView!.annotation = annotation
            }
            return pinView
    }
}


extension ShopViewController : UITableViewDataSource, UITableViewDelegate {
    func getHeaderCell() -> ShopHeaderViewCell{
        if self.headerCell == nil {
            self.headerCell = tableView.dequeueReusableCellWithIdentifier(headViewCellID) as! ShopHeaderViewCell
            self.headerCell.delegate = self
            
            //if self.headerCell.market != nil {
                self.headerCell.market = self.market
            //}
        }
        
        return self.headerCell
    }
    
    
    func showHeaderAnimate() {
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                let cell : ShopHeaderViewCell = self.getHeaderCell()
                let transfromScale = CGAffineTransformMakeScale(0.8, 0.8)
                let transfromNormal = CGAffineTransformMakeScale(1, 1)
            
                cell.headerView .backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.75)
            
                cell.addressLabel.hidden = true
            
                cell.marketLabel.transform = transfromScale
            
                cell.loveButton.transform = transfromNormal
                cell.addShopButton.transform = transfromNormal
                cell.reminderButton.transform = transfromNormal
            
                cell.headerConstrain.constant = 20
                cell.backButton.hidden = true
                cell.nextButton.hidden = true
            
            
                var viewFrame = self.headerCell.frame
                viewFrame.size.height = 80.0
                self.headerCell.frame = viewFrame
            }, completion: nil)
        
    }
    
    func hideHeaderAnimate() {
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            let transfromNormal = CGAffineTransformMakeScale(1, 1)
            let transfromScale = CGAffineTransformMakeScale(0.8, 0.8)
            
            let cell : ShopHeaderViewCell = self.getHeaderCell()
            
            cell.headerView.backgroundColor = UIColor.clearColor()
            cell.addressLabel.hidden = false
            
            
            cell.marketLabel.transform = transfromNormal
            cell.loveButton.transform = transfromScale
            cell.addShopButton.transform = transfromScale
            cell.reminderButton.transform = transfromScale
            
            cell.headerConstrain.constant = 47
            cell.backButton.hidden = false
            cell.nextButton.hidden = false
            
            var viewFrame = self.headerCell.frame
            viewFrame.size.height = 114.0
            self.headerCell.frame = viewFrame
            
            }, completion: nil)
        
    }
    
    // update background of header and animate
    func updateHeaderBackground() {
        let hasColor = tableView.contentOffset.y >= self.mapHeight
        
        if currentHasColor == !hasColor {
            if hasColor {
                showHeaderAnimate()
            } else {
                hideHeaderAnimate()
            }
            currentHasColor = hasColor
            tableView.reloadData()
        }
    }
    
    // table header
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getHeaderCell()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.headerCell != nil {
            return self.headerCell.frame.height
        }
        return 114.0
    }
    
    // number row on section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ShopViewCell = tableView.dequeueReusableCellWithIdentifier("shopViewCell", forIndexPath: indexPath) as! ShopViewCell
    
        cell.shop = self.shops[indexPath.row]
            
            // for collection view
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
        return cell
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? ShopViewCell else {
            return
        }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.shops[collectionView.tag].gallery.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell : ShopGalleryViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("cellImageShopView",
                forIndexPath: indexPath) as? ShopGalleryViewCell)!
            
            let shop = self.shops[collectionView.tag]
            
            if indexPath.item >= shop.imageGalary.count {
                return cell
            }
            
            let shopImage : UIImage = shop.imageGalary[indexPath.item] 
            cell.shopImage.image = shopImage
            
            return cell
    }
}

extension ShopViewController: AddingShopViewControllerDelegate, SearchViewControllerDelegate {
    func updateShops() {
        loadData()
    }
}

extension ShopViewController: shopHeaderDelegate {
    func updateMarketIndex(idx : Int) {
        var indexMarket = Int(self.markets.indexOf(market)!) + idx
        
        if (indexMarket == Int(markets.count)) {
            indexMarket = 0
        }
        else if (indexMarket == -1) {
            indexMarket = Int(markets.count) - 1
        }

        self.market = self.markets[indexMarket]
        mapView.selectAnnotation(self.annotationMapping[indexMarket], animated: true)
        
        // upload header data
        self.headerCell.market = self.market
        
        loadData()
    }
    
    func nextMarket() {
        print("next market")
        updateMarketIndex(1)
    }
    
    func backMarket() {
        print("prev market")
        updateMarketIndex(-1)
    }
}

