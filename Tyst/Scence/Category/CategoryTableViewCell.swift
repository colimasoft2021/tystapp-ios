//
//  CategoryTableViewCell.swift
//  Tyst
//
//  Created by hb on 28/02/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.addShadow(ofColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }

}
