//
//  BankListCell.swift
//  Tyst
//
//  Created by hb on 06/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class BankListCell: UICollectionViewCell {
    static let cellId = "BankListCell"
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblBankName: UILabel!
    
    @IBOutlet weak var imgLogo: UIImageView!

    var removeAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBg.addShadow(ofColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        viewBg.addCircularShadow(5)
        viewBg.layoutIfNeeded()
    }
    
    func confirgurCellData(data: AddBankAccount.ViewModel) {
        if let imgData = data.logo, imgData != "" {
            imgLogo.image = ConvertBase64StringToImage(imageBase64String: imgData)
        } else {
            imgLogo.image = #imageLiteral(resourceName: "img_topicon")
        }
        self.lblBankName.text = data.institutionName ?? ""
    }
    
    @IBAction func btnRemoveBank(_ sender: UIButton) {
        if self.removeAction != nil {
            self.removeAction!()
        }
    }
    
    func ConvertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
}

