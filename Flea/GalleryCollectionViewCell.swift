//
//  GalleryCollectionViewCell.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/25/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

@objc protocol GalleryCollectionViewCellDelegate {
    optional func tapImage(galleryColletionViewCell: GalleryCollectionViewCell, imageViewIndex: Int)
}

class GalleryCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet weak var galleryImageView: UIImageView!
    var delegate: GalleryCollectionViewCellDelegate?
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        galleryImageView.addGestureRecognizer(tap)
    }
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        delegate?.tapImage!(self, imageViewIndex: galleryImageView.tag)
    }
    
}
