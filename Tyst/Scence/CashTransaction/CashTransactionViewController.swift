//
//  CashTransactionViewController.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit
import FittedSheets

protocol CashTransactionDisplayLogic: class {
    func didReceiveBankTransaction(response: [BankTransaction.ViewModel]?, message: String, success: String)
    func didReceiveAddTipResponse(message: String, success: String)
    func didReceiveChangeTaxResponse(message: String, success: String)
    func didReceiveDeleteTransactionResponse(message: String, success: String)
    func didReceiveUpdateCategoryResponse(message: String, success: String)
    
}

class CashTransactionViewController: BaseViewController {
    
    //MARK: IBOutlet Constants
    var interactor: CashTransactionBusinessLogic?
    var router: (NSObjectProtocol & CashTransactionRoutingLogic & CashTransactionDataPassing)?
    
    @IBOutlet weak var receiptViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPreTotal: UILabel!
    @IBOutlet weak var lblEstimatedTax: UILabel!
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var imgReceipt: UIImageView!
    @IBOutlet weak var viewChangeTax: UIView!
    @IBOutlet weak var lblChangeTaxReason: UILabel!
    @IBOutlet weak var btndeleteTrans: UIButton!
    @IBOutlet weak var clctnView: UICollectionView!
    
    
    var transId = ""
    var changeTipAmount = ""
    var changeTaxAmount = ""
    var changeReason = ""
    var changereasonId = ""
    
    var bankdetail = [BankTransaction.ViewModel]()
    
    var imageArray = [String]() {
        didSet {
            self.clctnView.reloadData()
        }
    }
    
    // MARK: Class Instance
    class func instance() -> CashTransactionViewController? {
        return StoryBoard.CashTransaction.board.instantiateViewController(withIdentifier: AppClass.CashTransactionVC.rawValue) as? CashTransactionViewController
    }
    
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
        let interactor = CashTransactionInteractor()
        let presenter = CashTransactionPresenter()
        let router = CashTransactionRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        print(UserDefaultsManager.authToken)
    }
    
    //MARK: Class Method
    ///Method used for set intial setup of viewcontroller
    func setUpLayout() {
        self.title = "Transaction Details"
        btndeleteTrans.layer.shadowColor = UIColor.lightGray.cgColor
        btndeleteTrans.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btndeleteTrans.layer.shadowOpacity = 0.5
        btndeleteTrans.layer.shadowRadius = 1.0
        let request = BankTransaction.Request(transId: transId)
        interactor?.getBankTransaction(request: request)
    }
    
    /// Methos used for chnage date formate
    /// - Parameter date: date
    func changeDateFormate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        let datee = dateFormatterGet.date(from: date)
        return dateFormatterPrint.string(from: datee ?? Date())
    }
    
    /// Method used for calculate pretotal of tax
    /// - Parameters:
    ///   - total: total amount
    ///   - tax: tax amount
    ///   - tip: tip amount
    func calculatePreTotal(total: String, tax: String, tip: String) -> String {
        let diff = ((Float(tax) ?? 0.0) + (Float(tip) ?? 0.0))
        return String((Float(total) ?? 0.0) - diff)
    }
    
    /// Method used for set data to view
    /// - Parameter data: response data
    func setData(data : [BankTransaction.ViewModel]) {
        self.bankdetail = data
        self.lblStoreName.text = data[0].store_name
        self.lblDate.text = self.changeDateFormate(date: data[0].transaction_date ?? "")
        self.lblAddress.text = data[0].location ?? ""
        self.lblCategory.text = data[0].category
        self.lblEstimatedTax.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data[0].tax_amount ?? "0.00"))"
        self.lblTip.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data[0].tip_amount ?? "0.00"))"
        self.lblGrandTotal.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(data[0].transaction_amount ?? "0.00"))"
        self.lblPreTotal.text = "\(GlobalUtility.shared.roundOffTextTwoDigit((self.calculatePreTotal(total: (data[0].transaction_amount ?? "0.00"), tax: (data[0].tax_amount ?? "0.00"), tip: (data[0].tip_amount ?? "0.00")))))"
        if data[0].reason_id == "" {
            self.viewChangeTax.isHidden = true
            
        }else {
            self.viewChangeTax.isHidden = false
            self.lblChangeTaxReason.text = "Tax Change Reason: \(data[0].reason ?? "" )"
        }
        
        if data[0].receipt_image?.count == 0  {
            self.receiptViewHeightConstraint.constant = 0
        }else {
            self.receiptViewHeightConstraint.constant = 120
        }
       // self.imgReceipt.setImage(with: data[0].receipt_image?[0],placeHolder: UIImage(named: ""))
        self.imageArray =  data[0].receipt_image ?? [""]
    }
    
    
    //MARK: IBAction
    @IBAction func btnAddTipAction(_ sender: Any) {
        if let controller = AddTipViewController.instance() {
            controller.addTipCallBack = self
            let tip =  self.lblTip.text ?? ""
            controller.tipAmt = String(tip.dropFirst())
            controller.preTotal = String((self.lblPreTotal.text ?? "").dropFirst())
            controller.taxAmt = String((self.lblEstimatedTax.text ?? "").dropFirst())
            controller.total = String((self.lblGrandTotal.text ?? "").dropFirst())
            controller.tipPercentage = self.bankdetail[0].tipPercentage ?? ""
            controller.taxPercentage = "\(Double(self.bankdetail[0].taxPercentage ?? "0.0")! + AppConstants.extraTaxPercentage)"
            let sheetController = SheetViewController(controller: controller, sizes: [.fixed(250), .intrinsic])
            //SheetViewController(controller: controller, sizes: [.fixed(250), .halfScreen])
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
            controller.totalAmt = String((self.lblGrandTotal.text ?? "").dropFirst())
            controller.tipPercentage = self.bankdetail[0].tipPercentage ?? ""
            controller.taxPercentage = "\(Double(self.bankdetail[0].taxPercentage ?? "0.0")! + AppConstants.extraTaxPercentage)"
            let sheetController = SheetViewController(controller: controller, sizes: [.fixed(250), .intrinsic])
            //SheetViewController(controller: controller, sizes: [.fixed(320), .halfScreen])
            self.present(sheetController, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnDeleteTranAction(_ sender: Any) {
        guard internetAvailable() else { return }
        self.displayAlert(msg: AlertMessage.deleteTrans, ok: AlertMessage.yes, cancel: AlertMessage.no, okAction: {
            let request = DeleteTransaction.Request(transId: self.transId)
            self.interactor?.callDeleteTransaction(request: request)
        }, cancelAction: nil)
    }
    
    @IBAction func btnChangeCategoryAction(_ sender: Any) {
        if let VC = CategoryListViewController.instance() {
            VC.chngCtDelegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
}

//MARK: CollectionView Methods
extension CashTransactionViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    /// Method is called to get number of items to be displayed in collectionview
    ///
    /// - Parameters:
    ///   - collectionView: CollectionView
    ///   - section: Section
    /// - Returns: Return number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    /// Method is called to get cell for row at particular index
    ///
    /// - Parameters:
    ///   - collectionView: Collectionview
    ///   - indexPath: Indexpath
    /// - Returns: Return cell for indexpath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cashCell", for: indexPath) as? CashCollectionViewCell
        cell?.imgPicked.setImage(with: imageArray[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let customPopUp = ImageScrollerView.instance() {
            customPopUp.images = imageArray
            customPopUp.aIndex = indexPath.row
            customPopUp.modalPresentationStyle = .fullScreen
            self.present(customPopUp, animated: true, completion: nil)
        }
    }
}

//MARK: API Response
extension CashTransactionViewController: CashTransactionDisplayLogic {
    
    func didReceiveDeleteTransactionResponse(message: String, success: String) {
        if success == "1" {
            NotificationCenter.default.post(name: NSNotification.Name("ChangeTax"), object: nil)
            showTopMessage(message: message, type: .Success)
            self.navigationController?.popViewController(animated: true)
        }else {
            showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveChangeTaxResponse(message: String, success: String) {
        if success == "1" {
            let temp = self.bankdetail
            temp[0].tax_amount = changeTaxAmount
            temp[0].reason = changeReason
            temp[0].reason_id = changereasonId
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


extension CashTransactionViewController: AddTipProtocol {
    func addTipCall(amount: String) {
        if self.internetAvailable() {
            self.changeTipAmount = amount
            let request = AddTip.Request(transId: self.transId, tipAmount: amount)
            interactor?.callAddTip(request: request)
        }
    }
}

extension CashTransactionViewController: ChangeTaxAmountProtocol {
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

extension CashTransactionViewController: ChangeCategory {
    func changeStatus(categoryId: String, categoryName: String) {
         if self.internetAvailable() {
            let request = UpdateCategory.Request(transId: self.transId, categoryId: categoryId, categoryName: categoryName)
            interactor?.callUpdateCategory(request: request)
        }
    }
    
    
}
