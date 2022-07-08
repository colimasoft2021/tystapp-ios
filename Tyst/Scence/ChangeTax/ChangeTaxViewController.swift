//
//  ChangeTaxViewController.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol ChangeTaxDisplayLogic: class {
    func didReceiveChangeTaxList(response: [ChangeTax.ViewModel]?, message: String, Success: String)
}

class ChangeTaxViewController: BaseViewController {
    
    //MARK: IBAction Constants
    var interactor: ChangeTaxBusinessLogic?
    var router: (NSObjectProtocol & ChangeTaxRoutingLogic & ChangeTaxDataPassing)?
    
    @IBOutlet weak var txtFieldAmount: UITextField!
    @IBOutlet weak var txtFieldREason: UITextField!
    
    var chnageTaxData = [ChangeTax.ViewModel]()
    var pickerView = UIPickerView()
    var taxAmt = ""
    var preTotal = ""
    var reason = ""
    var reasonId = ""
    var tipAmt = ""
    var totalAmt = ""
    var tipPercentage = ""
    var taxPercentage = ""
    
    var newPreTotal = 0.0
    
    var changeTaxCallBack : ChangeTaxAmountProtocol?
    
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
        let interactor = ChangeTaxInteractor()
        let presenter = ChangeTaxPresenter()
        let router = ChangeTaxRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Class Instance
    class func instance() -> ChangeTaxViewController? {
        return StoryBoard.ChangeTax.board.instantiateViewController(withIdentifier: AppClass.ChangeTaxVC.rawValue) as? ChangeTaxViewController
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    //MARK: Class Method
    /// Method used for initial setup of viewcontroller
    func setupLayout() {
        interactor?.callChangeTaxListAPI()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.txtFieldREason.inputView = pickerView
        self.txtFieldREason.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        if taxAmt != "0.00" {
            self.txtFieldAmount.text = taxAmt
        }
        self.txtFieldREason.text = reason
        
        newPreTotal = Double((Float(totalAmt.replacingOccurrences(of: ",", with: ""))! - Float(tipAmt.replacingOccurrences(of: ",", with: ""))!))
    }
    
    //MARK: IBAction
    @objc func doneButtonClicked(_ sender: Any) {
        let aValue = self.chnageTaxData[self.pickerView.selectedRow(inComponent: 0)]
        self.txtFieldREason.text = aValue.reason ?? ""
        self.reasonId = aValue.reason_id ?? ""
    }
    
    @IBAction func btnChangeTaxAction(_ sender: Any) {
        let text = self.txtFieldAmount.text ?? ""
        if self.txtFieldAmount.text == "" {
            showTopMessage(message: AlertMessage.taxAmountCheck, type: .Error)
        }
        else if (((Float(newPreTotal)) * (Float(taxPercentage)!)) / 100.0) < (Float(self.txtFieldAmount.text ?? "")!) {
            showTopMessage(message: "Tax percentage should not be more than \(taxPercentage)%", type: .Error)
        }
        else if Float(text.replacingOccurrences(of: ",", with: ""))! > (Float (self.preTotal.replacingOccurrences(of: ",", with: ""))! + Float (self.taxAmt.replacingOccurrences(of: ",", with: ""))!) {
            showTopMessage(message: AlertMessage.taxAmountLess, type: .Error)
        }
        else if ((Float (self.totalAmt.replacingOccurrences(of: ",", with: ""))! - (Float(txtFieldAmount.text ?? "0.0")! + Float(self.tipAmt.replacingOccurrences(of: ",", with: ""))!)) == 0) {
            showTopMessage(message: AlertMessage.pretotalNotZero, type: .Error)
        }
        else if self.txtFieldREason.text == "" {
            showTopMessage(message: AlertMessage.selectReason, type: .Error)
        }else {
            if internetAvailable() {
                changeTaxCallBack?.changeTaxCall(amount: self.txtFieldAmount.text ?? "" , reason: self.txtFieldREason.text ?? "" , reasonId: self.reasonId)
            }
        }
    }
}

//MARK: UIPicker Methods
extension ChangeTaxViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chnageTaxData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.chnageTaxData[row].reason
    }
}

//MARK: API Response
extension ChangeTaxViewController: ChangeTaxDisplayLogic {
    func didReceiveChangeTaxList(response: [ChangeTax.ViewModel]?, message: String, Success: String) {
        if Success == "1" {
            if let data = response {
                self.chnageTaxData = data
            }
        }else {
            showTopMessage(message: message, type: .Error)
        }
    }
}
