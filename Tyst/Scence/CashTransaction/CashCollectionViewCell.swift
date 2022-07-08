//
//  CashCollectionViewCell.swift
//  Tyst
//
//  Created by hb on 11/12/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class CashCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPicked: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgPicked.layer.cornerRadius = 3
        imgPicked.clipsToBounds = true
        imgPicked.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgPicked.layoutIfNeeded()
        imgPicked.layer.cornerRadius = 4
    }
}
