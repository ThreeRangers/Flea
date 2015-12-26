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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayShopSegue" {
            var newShop = Shop()
            let indexPath = NSIndexPath(forRow: 0, inSection: InfoSection)
            let edittingCell = tableView.cellForRowAtIndexPath(indexPath) as! shopInfoTableViewCell
            edittingCell.setInfo({ (edittingShop, error) -> () in
                if edittingShop != nil {
                    newShop = edittingShop!
                    self.upLoadShopToParse(newShop)
                } else {
                    print("Error call retweet API",error)
                }
            })
        }
    }
    
    func upLoadShopToParse(newShop: Shop) {
//        newShop.uploadInfoDataWithImg()
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
            cell.delegate = self
            cell.backgroundColor = UIColor.whiteColor()
            return cell
    }
    
    func tapImage(galleryColletionViewCell: GalleryCollectionViewCell, image: UIImage?) {
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
            
        }
    }
    
}




