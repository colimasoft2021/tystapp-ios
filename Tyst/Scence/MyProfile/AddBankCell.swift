//
//  AddBankCell.swift
//  Tyst
//
//  Created by hb on 08/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class AddBankCell: UICollectionViewCell {
    static let cellId = "AddBankCell"
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewBG: UIView!
    var addAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.addShadow(ofColor: #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1))
    }
    
    
    @IBAction func btnAddAction(_ sender: UIButton) {
        if self.addAction != nil {
            self.addAction!()
        }
    }
    
}
