//
//  ExportCell.swift
//  Tyst
//
//  Created by hb on 08/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class ExportCell: UITableViewCell {

    static let cellId = "ExportCell"
    
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblSalesTax: UILabel!
    
    var buttonDownloadTapAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        viewBG.addCircularShadow(10)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        viewBG.addCircularShadow(10)
        viewBG.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnDownloadAction(_ sender: UIButton) {
        if self.buttonDownloadTapAction != nil {
            self.buttonDownloadTapAction!()
        }
    }
    
    func setData(data: Export.ViewModel) {
        lblTax.text = "Tax Applied: \(GlobalUtility.shared.roundOffTextTwoDigit(data.totalTaxAmount ?? "0.00"))"
        lblamount.text = "Total Amount: \(GlobalUtility.shared.roundOffTextTwoDigit(data.totalTransactionAmount ?? "0.00"))"
        let salesAmt = Double(data.totalTransactionAmount ?? "0.00")! - Double(data.totalTaxAmount ?? "0.00")!
        lblSalesTax.text = "Sales Amount: \((GlobalUtility.shared.roundOffTextTwoDigit(String(salesAmt))))"
        lblDate.text = createDate(start: data.startDate ?? "0000-00-00", end: data.endDate ?? "0000-00-00")
    }

    func createDate(start: String, end: String) -> String {
        let dateForate = DateFormatter()
        dateForate.dateFormat = "yyyy-MM-dd"
        var date = ""
        if let startDate = dateForate.date(from: start), let endDate = dateForate.date(from: end) {
            dateForate.dateFormat = "dd MMM yyyy"
            date = "From: \(dateForate.string(from: startDate)) - \(dateForate.string(from: endDate))"
        }
        return date
    }
}
