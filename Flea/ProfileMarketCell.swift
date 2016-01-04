//
//  ProfileMarketCell.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/29/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class ProfileMarketCell: UITableViewCell {
    
    @IBOutlet weak var marketBgImgView: UIImageView!
    
    @IBOutlet weak var marketNameLabel: UILabel!
    
    @IBOutlet weak var marketAddressLabel: UILabel!
    
    
    @IBOutlet weak var maketTimeLabel: UILabel!
    
    var market: Market? {
        didSet {
            if let market = market {
                self.marketBgImgView.image = market.image
                self.marketNameLabel.text = market.name
                self.marketAddressLabel.text = market.address
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = myDateFormat
                self.maketTimeLabel.text = dateFormatter.stringFromDate(market.date_from!)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
