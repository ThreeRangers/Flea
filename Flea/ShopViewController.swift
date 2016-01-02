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

var headViewCellID = "shopHeaderViewCell"
class ShopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var marketImage: UIImageView!
    var headerCell : ShopHeaderViewCell!
    
    static let mapHeight = CGFloat(360.0)
    
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
        
        if market == nil {
            return
        }
        
        loadData()
        
        loadMapView()
    
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
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
    }
}


extension ShopViewController : MKMapViewDelegate {
    func loadMapView() {
        // Set the table views header cell and delegate
        let tableHeaderViewHeight:CGFloat = ShopViewController.mapHeight
        self.mapView = MKMapView(frame: CGRectMake(0,0, self.view.frame.width, tableHeaderViewHeight))
        
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
    
    // update background of header and animate
    func updateHeaderBackground() {
        let hasColor = tableView.contentOffset.y >= ShopViewController.mapHeight
        
        if currentHasColor == !hasColor {
            let cell = self.getHeaderCell()
            
            print("==> update the cell header when offset change \(cell)")
            if hasColor {
                cell.headerView .backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.75)
            } else {
                cell.headerView.backgroundColor = UIColor.clearColor()
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

extension ShopViewController: AddingShopViewControllerDelegate {
    func updateShops() {
        loadData()
    }
}

extension ShopViewController: shopHeaderDelegate {
    func updateMarketIndex(idx : Int) {
        var indexMarket = Int(self.markets.indexOf(market)!) + idx
        
        if (indexMarket == Int(markets.count) - 1) {
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

