//
//  BankTransactionViewController.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit
import FittedSheets

protocol BankTransactionDisplayLogic: class {
    func didReceiveBankTransaction(response: [BankTransaction.ViewModel]?, message: String, success: String)
    func didReceiveAddTipResponse(message: String, success: String)
    func didReceiveChangeTaxResponse(message: String, success: String)
    func didReceiveUpdateCategoryResponse(message: String, success: String)
}
protocol AddTipProtocol {
    func addTipCall(amount: String)
}
protocol ChangeCategory {
    func changeStatus(categoryId: String, categoryName: String)
}

protocol ChangeTaxAmountProtocol {
    func changeTaxCall(amount: String, reason: String, reasonId: String)
}

class BankTransactionViewController: BaseViewController {
    
    //MARK: IBOutlet Constants
    var interactor: BankTransactionBusinessLogic?
    var router: (NSObjectProtocol & BankTransactionRoutingLogic & BankTransactionDataPassing)?
    
    @IBOutlet weak var lblTransactionNumber: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPreTotal: UILabel!
    @IBOutlet weak var lblEstimatedTax: UILabel!
    @IBOutlet weak var lblEstimatedTaxPercentage: UILabel!
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var viewTaxChange: UIView!
    @IBOutlet weak var lblTaxChangereason: UILabel!
    @IBOutlet weak var viewOriginaltaxBottom: UIView!
    @IBOutlet weak var lblOriginalTaxPercentage: UILabel!
    
    var transId = ""
    var changeTipAmount = ""
    var changeTaxAmount = ""
    var changeReason = ""
    var changereasonId = ""
    var bankdetail = [BankTransaction.ViewModel]()
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = BankTransactionInteractor()
        let presenter = BankTransactionPresenter()
        let router = BankTransactionRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Class Instance
    class func instance() -> BankTransactionViewController? {
        return StoryBoard.BankTransaction.board.instantiateViewController(withIdentifier: AppClass.BankTransactionVC.rawValue) as? BankTransactionViewController
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    //MARK: ClassMethod
    //Method used for initial setup of viewcontroller
    func setupLayout() {
        self.title = "Transaction Details"
        let request = BankTransaction.Request(transId: transId)
        interactor?.getBankTransaction(request: request)
    }
    
    /// Method used for chnage adte formate
    /// - Parameter date: date
    func changeDateFormate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        let datee = dateFormatterGet.date(from: date)
        return dateFormatterPrint.string(from: datee ?? Date())
    }
    
    /// Method used for calculate pretotal
    /// - Parameters:
    ///   - total: toal amount
    ///   - tax: tax amount
    ///   - tip: tip amount
    func calculatePreTotal(total: String, tax: String, tip: String) -> String {
        let diff = ((Float(tax) ?? 0.0) + (Float(tip) ?? 0.0))
        return String((Float(total) ?? 0.0) - diff)
    }
    
    /// Method used for calculate Tax
    /// - Parameters:
    ///   - total: toal amount
    ///   - tax: tax amount
    ///   - tip: tip amount
    func calculateTax(total: String, tax: String, tip: String) -> String {
        let preTotal = (Float(total) ?? 0.0) - (Float(tip) ?? 0.0)
        let taxPer = (((Float(tax) ?? 0.0)) / (Float(preTotal))) * 100
        return String(taxPer)
    }
    
    /// Method used to set data
    /// - Parameter data: response data
    func setData(data : [BankTransaction.ViewModel]) {
        self.bankdetail = data
        self.lblTransactionNumber.text = data[0].transaction_id
        self.lblStoreName.text = data[0].store_name
        self.lblDate.text = self.changeDateFormate(date: data[0].transaction_date ?? "")
        self.lblCategory.text = data[0].category
        
        self.lblTip.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data[0].tip_amount ?? "0.00"))"
        self.lblTotal.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data[0].transaction_amount ?? "0.00"))"
        
        self.lblOriginalTaxPercentage.text = "Original Tax(%):\("\(GlobalUtility.shared.roundOffTextTwoDigitValue(data[0].taxPercentage ?? "0.00"))")%"
        
        if data[0].reason_id == "" {
            self.viewTaxChange.isHidden = true
            self.lblEstimatedTax.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data[0].tax_amount ?? "0.00"))"
            
            self.lblPreTotal.text = "\(GlobalUtility.shared.roundOffTextTwoDigit((self.calculatePreTotal(total: (data[0].transaction_amount ?? "0.00"), tax: (data[0].tax_amount ?? "0.00"), tip: (data[0].tip_amount ?? "0.00")))))"
            self.lblEstimatedTaxPercentage.text = "\(GlobalUtility.shared.roundOffTextTwoDigitValue((self.calculateTax(total: (data[0].transaction_amount ?? "0.00"), tax: (data[0].tax_amount ?? "0.00"), tip: (data[0].tip_amount ?? "0.00")))))%"
        }else {
            self.viewTaxChange.isHidden = false
            self.lblTaxChangereason.text = "Tax Change Reason: \(data[0].reason ?? "")"
            self.lblEstimatedTax.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data[0].changedTaxAmount ?? "0.00"))"
            
            self.lblPreTotal.text = "\(GlobalUtility.shared.roundOffTextTwoDigit((self.calculatePreTotal(total: (data[0].transaction_amount ?? "0.00"), tax: (data[0].changedTaxAmount ?? "0.00"), tip: (data[0].tip_amount ?? "0.00")))))"
            self.lblEstimatedTaxPercentage.text = "\(GlobalUtility.shared.roundOffTextTwoDigitValue((self.calculateTax(total: (data[0].transaction_amount ?? "0.00"), tax: (data[0].changedTaxAmount ?? "0.00"), tip: (data[0].tip_amount ?? "0.00")))))%"
        }
        
        if data[0].location == "" {
            self.viewOriginaltaxBottom.isHidden = true
        }else {
            self.viewOriginaltaxBottom.isHidden = false
        }
        
    }
    
    //MARK: IBAction
    @IBAction func btnAddTipAction(_ sender: Any) {
        if let controller = AddTipViewController.instance() {
            controller.addTipCallBack = self
            let tip =  self.lblTip.text ?? ""
            controller.tipAmt = String(tip.dropFirst())
            controller.preTotal = String((self.lblPreTotal.text ?? "").dropFirst())
            controller.taxAmt = String((self.lblEstimatedTax.text ?? "").dropFirst())
            controller.total = String((self.lblTotal.text ?? "").dropFirst())
            controller.tipPercentage = self.bankdetail[0].tipPercentage ?? ""
            controller.taxPercentage = "\(Double(self.bankdetail[0].taxPercentage ?? "0.0")! + AppConstants.extraTaxPercentage)"
            let sheetController = SheetViewController(controller: controller, sizes: [.fixed(250), .halfScreen])
            self.present(sheetController, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func btnChangeTaxAction(_ sender: Any) {
        if let controller = ChangeTaxViewController.instance() {
            controller.changeTaxCallBack = self
            let tax =  self.lblEstimatedTax.text ?? ""
            let tip =  self.lblTip.text ?? ""
            controller.taxAmt = String(tax.dropFirst())
            controller.preTotal = String((self.lblPreTotal.text ?? "").dropFirst())
            controller.reason = self.bankdetail[0].reason ?? ""
            controller.reasonId = self.bankdetail[0].reason_id ?? ""
            controller.tipAmt = String(tip.dropFirst())
            controller.totalAmt = String((self.lblTotal.text ?? "").dropFirst())
            controller.tipPercentage = self.bankdetail[0].tipPercentage ?? ""
            //self.bankdetail[0].taxPercentage ?? ""
            controller.taxPercentage = "\(Double(self.bankdetail[0].taxPercentage ?? "0.0")! + AppConstants.extraTaxPercentage)"
            let sheetController = SheetViewController(controller: controller, sizes: [.fixed(320), .halfScreen])
            self.present(sheetController, animated: false, completion: nil)
        }
    }
    
    @IBAction func brtnChangeCategoryAction(_ sender: Any) {
        if let VC = CategoryListViewController.instance() {
            VC.chngCtDelegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

//MARK: API Response
extension BankTransactionViewController: BankTransactionDisplayLogic {
    
    func didReceiveChangeTaxResponse(message: String, success: String) {
        if success == "1" {
            let temp = self.bankdetail
            temp[0].tax_amount = changeTaxAmount
            temp[0].reason = changeReason
            temp[0].reason_id = changereasonId
            if temp[0].reason_id ?? "" != "" {
                temp[0].changedTaxAmount = changeTaxAmount
            }
            self.bankdetail = temp
            self.setData(data: temp)
            self.dismiss(animated: false, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name("ChangeTax"), object: nil)
        }else {
            showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveAddTipResponse(message: String, success: String) {
        if success == "1" {
            let temp = self.bankdetail
            temp[0].tip_amount = changeTipAmount
            self.bankdetail = temp
            self.setData(data: temp)
            self.dismiss(animated: false, completion: nil)
        }else {
            showTopMessage(message: message, type: .Error)
        }
    }
    
    
    func didReceiveBankTransaction(response: [BankTransaction.ViewModel]?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                self.setData(data: data)
            }
        }else {
            showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveUpdateCategoryResponse(message: String, success: String) {
        if success == "1" {
            showTopMessage(message: message, type: .Success)
            NotificationCenter.default.post(name: NSNotification.Name("ChangeTax"), object: nil)
            let request = BankTransaction.Request(transId: transId)
            interactor?.getBankTransaction(request: request)
        }else {
            showTopMessage(message: message, type: .Error)
        }
    }
}

//MARK: Custom Add Tip Protocol
extension BankTransactionViewController: AddTipProtocol {
    func addTipCall(amount: String) {
        if self.internetAvailable() {
            self.changeTipAmount = amount
            let request = AddTip.Request(transId: self.transId, tipAmount: amount)
            interactor?.callAddTip(request: request)
        }
    }
}

//MARK: Custom Change Tax Protocol
extension BankTransactionViewController: ChangeTaxAmountProtocol {
    func changeTaxCall(amount: String, reason: String, reasonId: String) {
        if self.internetAvailable() {
            self.changeTaxAmount = amount
            self.changeReason = reason
            self.changereasonId = reasonId
            let request = ChangeTaxAmount.Request(transId: self.transId, taxAmount: amount, reasonId: reasonId)
            interactor?.callChangeTax(request: request)
        }
    }
}

//MARK: Custom Change Category Protocol
extension BankTransactionViewController: ChangeCategory {
    func changeStatus(categoryId: String, categoryName: String) {
        if self.internetAvailable() {
            let request = UpdateCategory.Request(transId: self.transId, categoryId: categoryId, categoryName: categoryName)
            interactor?.callUpdateCategory(request: request)
        }
    }
}
