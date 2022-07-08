//
//  HomeCell.swift
//  Tyst
//
//  Created by hb on 04/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    static let cellID = "HomeCell"
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var viewAddAccount: UIView!
    @IBOutlet weak var btnError: UIButton!
    var btnErrorClouser: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBg.addShadow(ofColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
    
    func setData(data: Home.ViewModel.InstitutionDetail) {
        self.lblTax.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data.taxAmount ?? "0.00"))"
        self.lblamount.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data.transactionAmount ?? "0.00"))"
        self.lblPaymentType.text = data.institutionName
        if data.errorCode ?? "" == "" {
            self.btnError.isHidden = true
        }else {
            self.btnError.isHidden = false
        }
    }
    
    @IBAction func btnErrorAction(_ sender: Any) {
        btnErrorClouser!()
    }
    
}
