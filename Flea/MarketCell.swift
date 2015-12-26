//
//  MarketCell.swift
//  Flea
//
//  Created by minh on 12/26/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class MarketCell: UICollectionViewCell {    
    
    @IBOutlet weak var marketImage: UIImageView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var imageViewContent : UIImageView = UIImageView()
    
    @IBOutlet weak var imageCoverView: UIView!
    
    
    var market: Market? {
        didSet {
            if let market = market {
                self.marketLabel.text = market.name!
                self.marketImage.image = market.image
                self.locationLabel.text = market.address
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM h:mm"
                self.startDateLabel.text = dateFormatter.stringFromDate(market.date_from!)
            }
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        
        let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
        
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        marketLabel.transform = CGAffineTransformMakeScale(scale, scale)
        
        locationLabel.alpha = delta
        startDateLabel.alpha = delta
    }
    
}
