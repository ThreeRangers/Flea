//
//  ProfileNotificationCell.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 1/3/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import UIKit

class ProfileNotificationCell: UITableViewCell {

    @IBOutlet weak var notificationImgView: UIImageView!
    
    @IBOutlet weak var notificationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationImgView.layer.cornerRadius = 8.0
        notificationImgView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
