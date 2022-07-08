//
//  AddTipViewController.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class AddTipViewController: BaseViewController {
    
    //MARK: IBOutlet Constants
    @IBOutlet weak var txtField: UITextField!
    var tipAmt = ""
    var preTotal = ""
    var total = ""
    var taxAmt = ""
    
    var tipPercentage = ""
    var taxPercentage = ""
    var newPreTotal = 0.0
    
    var addTipCallBack : AddTipProtocol?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if tipAmt != "0.00" {
            self.txtField.text = tipAmt
        }
    }
    
    /// Method used for calculate pretotal
    /// - Parameter tip: tip amount
    func newPreTotalCalculate(tip: String) -> Float {
        return Float(total.replacingOccurrences(of: ",", with: ""))! - Float(tip.replacingOccurrences(of: ",", with: ""))!
    }
    
    //MARK: IBAction
    @IBAction func btnAddTipTapped(_ sender: Any) {
        let txtFieldText = self.txtField.text ?? ""
        if self.txtField.text == "" {
            showTopMessage(message: AlertMessage.tipAmount.replacingOccurrences(of: ",", with: ""), type: .Error)
        } else if (((Float(total.replacingOccurrences(of: ",", with: ""))!) * (Float(taxPercentage)!)) / 100.0) < (Float(self.txtField.text ?? "")!) {
            showTopMessage(message: "Tax percentage should not be more than \(tipPercentage)%", type: .Error)
        } else if (((Float(newPreTotalCalculate(tip: self.txtField.text ?? ""))) * (Float(taxPercentage)!)) / 100.0) < (Float(taxAmt.replacingOccurrences(of: ",", with: ""))!) {
            showTopMessage(message: "Tax percentage should not be more than \(taxPercentage)%", type: .Error)
        } else if Float(txtFieldText)! > (Float (self.preTotal.replacingOccurrences(of: ",", with: ""))! +  Float(self.tipAmt.replacingOccurrences(of: ",", with: ""))!) {
            showTopMessage(message: AlertMessage.tipAmountLess, type: .Error)
        } else if ((Float (self.total.replacingOccurrences(of: ",", with: ""))! - (Float(txtFieldText)! + Float(self.taxAmt.replacingOccurrences(of: ",", with: ""))!)) == 0) {
            showTopMessage(message: AlertMessage.pretotalNotZero, type: .Error)
        } else {
            if internetAvailable() {
                addTipCallBack?.addTipCall(amount: self.txtField.text ?? "")
            }
        }
    }
    
    // MARK: Class Instance
    class func instance() -> AddTipViewController? {
        return StoryBoard.AddTipViewController.board.instantiateViewController(withIdentifier: AppClass.AddTipViewVC.rawValue) as? AddTipViewController
    }
}
