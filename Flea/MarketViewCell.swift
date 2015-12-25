//
//  MarketViewCell.swift
//  Flea
//
//  Created by minh on 12/23/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//


import UIKit

class MarketViewCell :UICollectionViewCell, NTTansitionWaterfallGridViewProtocol{
    var imageName : String?
    
    @IBOutlet weak var marketImage: UIImageView!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var imageViewContent : UIImageView = UIImageView()
    
    var market : Market! {
        didSet {
            self.marketLabel.text = market.name!
            self.marketImage.image = market.image
            self.locationLabel.text = market.location
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM h:mm"
            self.startDateLabel.text = dateFormatter.stringFromDate(market.fromDate!)
        }
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.lightGrayColor()
//        contentView.addSubview(imageViewContent)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageViewContent.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
//        imageViewContent.image = UIImage(named: imageName!)
//    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
}