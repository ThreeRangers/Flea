//
//  AddingShopViewController.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/17/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

//Each shop have maximum 4 photo
let GallerryMaxCnt = 4
let InfoSection = 0
let GallerySection = 1
let ProfieImgViewIndex = 4


class AddingShopViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var imgViewPickerIndex = 0
    var market : Market!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        
        //Add notificatioon when tap Profile Image
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector:"tapProfileImage",
            name:qTapImageNotificationKey,
            object: nil
        )
        
        // custom navigation bar
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = MyColor.Colors.OrangePrimary
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        saveShop()
     
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func backAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func saveShop() {
        var newShop = Shop()
        
        // Prepare for shop info data from ShopInfoCell
        let indexPath = NSIndexPath(forRow: 0, inSection: InfoSection)
        let edittingCell = tableView.cellForRowAtIndexPath(indexPath) as! shopInfoTableViewCell
        edittingCell.setInfo({ (edittingShop, error) -> () in
            if edittingShop != nil {
                newShop = edittingShop!
            } else {
                print("Error call retweet API",error)
                return
            }
        })
        // Prepare for shop gallery data from shopGalleryCell
        let galleryCellIndexPath = NSIndexPath(forRow: 0, inSection: GallerySection)
        let galleryEdittingCell = tableView.cellForRowAtIndexPath(galleryCellIndexPath) as! shopGalleryTableViewCell
        if galleryEdittingCell.getGalleryFile().count > 0 {
            newShop.gallery = galleryEdittingCell.getGalleryFile()
            print("newShop set gallery",newShop.gallery)
        }
        
        // save market reference
        let marketRelation = newShop.relationForKey("market")
        marketRelation.addObject(self.market)
        
        self.upLoadShopToParse(newShop)
    }
    
    func upLoadShopToParse(newShop: Shop) {
        newShop.uploadInfoDataWithImg()
    }
    
    
}

extension AddingShopViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == InfoSection {
            print("InfoCell")
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! shopInfoTableViewCell
            return cell
        } else if indexPath.section == GallerySection {
            let cell = tableView.dequeueReusableCellWithIdentifier("GalleryCell", forIndexPath: indexPath) as! shopGalleryTableViewCell
            return cell
        } else {
            print("OOPS, Out of section number, return default cell")
            let cell = UITableViewCell()
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            guard let tableViewCell = cell as? shopGalleryTableViewCell else { return }
            tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        }
    }
    
    func tapProfileImage() {
        imgViewPickerIndex = ProfieImgViewIndex
        loadImageFrom(.PhotoLibrary)
    }
    
}

extension AddingShopViewController: UICollectionViewDelegate, UICollectionViewDataSource, GalleryCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            return GallerryMaxCnt
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell",
                forIndexPath: indexPath) as! GalleryCollectionViewCell
            //set tag for gallery image view
            cell.galleryImageView.tag = indexPath.item
            cell.delegate = self
            cell.backgroundColor = UIColor.whiteColor()
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    //    func tapImage(galleryColletionViewCell: GalleryCollectionViewCell, image: UIImage?) {
    //        loadImageFrom(.PhotoLibrary)
    //    }
    func tapImage(galleryColletionViewCell: GalleryCollectionViewCell, imageViewIndex: Int) {
        imgViewPickerIndex = imageViewIndex
        print("imgViewPickerIndex",imgViewPickerIndex)
        loadImageFrom(.PhotoLibrary)
    }
    
    
    func loadImageFrom(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // User selected an image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickImage(image)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // User cancel the image picker
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pickImage(image: UIImage) {
        if imgViewPickerIndex == ProfieImgViewIndex {
            let indexPath = NSIndexPath(forRow: 0, inSection: InfoSection)
            let edittingCell = tableView.cellForRowAtIndexPath(indexPath) as! shopInfoTableViewCell
            edittingCell.shopProfileImgView.image = image
        } else {
            let indexPath = NSIndexPath(forRow: 0, inSection: GallerySection)
            let edittingCell = tableView.cellForRowAtIndexPath(indexPath) as! shopGalleryTableViewCell
            let galleryCollectionCell = edittingCell.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: imgViewPickerIndex, inSection: 0)) as! GalleryCollectionViewCell
            galleryCollectionCell.galleryImageView.image = image
        }
    }
    
}




