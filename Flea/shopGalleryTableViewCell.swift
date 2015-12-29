//
//  shopGalleryTableViewCell.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/21/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class shopGalleryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.backgroundColor = UIColor.whiteColor()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
            
            collectionView.delegate = dataSourceDelegate
            collectionView.dataSource = dataSourceDelegate
            collectionView.tag = row
            collectionView.reloadData()
    }
    
    func getGalleryFile() -> [PFFile] {
        var files = [PFFile]()
        for var i = 0; i < GallerryMaxCnt; i++ {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell
            if let image = cell.galleryImageView.image {
                let imageFile = PFFile(name: "galleryImg\(i)", data: UIImageJPEGRepresentation(image, 0.4)!)
                print("Q_debug imageFile:",imageFile)
                files.append(imageFile!)
                print("Q_debug: files",files.count)

            }
        }
        print("Q_debug: files",files.count)
        return files
        
    }
    
}
