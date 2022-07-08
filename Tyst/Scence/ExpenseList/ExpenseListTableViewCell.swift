//
//  ExpenseListTableViewCell.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit


class ExpenseListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblrestName: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTaxApplied: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgTaxLogo: UIImageView!
    @IBOutlet weak var lblAccountType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBg.addShadow(ofColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }

    func setDate(data: ExpenseList.ViewModel.TransactionData,instId: String) {
        if instId == "" {
            self.lblPlace.isHidden = false
            self.lblAccountType.isHidden = true
        }else {
            self.lblPlace.isHidden = true
            self.lblAccountType.isHidden = false
        }
        
        self.lblrestName.text = data.store_name ?? ""
        self.lbldate.text = self.changeDateFormate(date: data.transaction_date ?? "")
        self.lblPlace.text = data.location ?? ""
        self.lblType.text = data.category ?? ""
        self.lblTotalAmount.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data.transaction_amount ?? "0.00"))"
        self.lblTaxApplied.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data.tax_amount ?? "0.00"))"
        self.lblAccountType.text = data.account_name ?? ""
        
        if data.reasonId ?? "" == "" {
            if Float(data.tax_amount ?? "0.0")! > 0.0 {
                imgTaxLogo.image = UIImage(named: "tax_applied")
                self.lblTaxApplied.textColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            }else {
                 imgTaxLogo.image = UIImage(named: "tax_notapplied")
                self.lblTaxApplied.textColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                self.lblTaxApplied.text = "N/A"
            }
        }else {
            if Float(data.changedTaxAmount ?? "0.0")! > 0.0 {
                imgTaxLogo.image = UIImage(named: "tax_applied")
                self.lblTaxApplied.textColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            }else {
                 imgTaxLogo.image = UIImage(named: "tax_notapplied")
                self.lblTaxApplied.textColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                self.lblTaxApplied.text = "N/A"
            }
        }
        
    }
    
    func changeDateFormate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        let datee = dateFormatterGet.date(from: date)
        return dateFormatterPrint.string(from: datee ?? Date())
    }

}
