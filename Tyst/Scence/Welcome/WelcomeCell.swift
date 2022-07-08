//
//  WelcomeCell.swift
//  PickUpUser
//
//  Created by hb on 19/12/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class WelcomeCell: UICollectionViewCell {
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewTax: UIView!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //imgHeightConstraint.constant =  AppConstants.screenHeight - 300
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = scrView {
            scrView.layoutIfNeeded()
        }
    }
}
