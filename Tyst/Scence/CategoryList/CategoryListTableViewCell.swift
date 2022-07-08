//
//  CategoryListTableViewCell.swift
//  Tyst
//
//  Created by hb on 30/03/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.addShadow(ofColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
}
