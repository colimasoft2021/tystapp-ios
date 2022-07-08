//
//  ExpenseListViewController.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit
import CRRefresh

protocol ExpenseListDisplayLogic: class {
    func didReceiveAllData(response: ExpenseList.ViewModel?, message: String, success: String,currPage: String, nextPage: Bool)
}
protocol SelectCategory {
    func setCategory(accountId: String, accountName: String)
}


class ExpenseListViewController: BaseViewControllerWithAd {
    
    //MARK: IBAction Constants
    var interactor: ExpenseListBusinessLogic?
    var router: (NSObjectProtocol & ExpenseListRoutingLogic & ExpenseListDataPassing)?
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDateSelect: UIButton!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTaxApplied: UILabel!
    @IBOutlet weak var serachBar: UISearchBar!
    @IBOutlet weak var lblReceiptType: UILabel!
    @IBOutlet weak var viewRightButton: UIView!
    @IBOutlet weak var imGFilter: UIImageView!
    var navTitle = ""
    var startDate = ""
    var endDate = ""
    var currYear = ""
    var instId = ""
    var accountId = ""
    
    var message = ""
    var nextPageAvailable = false
    var pageIndex = 1
    var dataLoading = false
    
    var pullRefresh = false
    
    var expenseListData = [ExpenseList.ViewModel.TransactionData]()
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Class Instance
    class func instance() -> ExpenseListViewController? {
        return StoryBoard.ExpenseList.board.instantiateViewController(withIdentifier: AppClass.ExpenseListVC.rawValue) as? ExpenseListViewController
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = ExpenseListInteractor()
        let presenter = ExpenseListPresenter()
        let router = ExpenseListRouter()
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
        setupLayout()
        if self.accountId == "" {
            self.imGFilter.isHidden = true
        } else {
            self.imGFilter.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.accountId == "" {
            self.imGFilter.isHidden = true
        } else {
            self.imGFilter.isHidden = false
        }
    }
    
    //MARK: Class Method
    //Method used for set initial setup of viewcontroller
    func setupLayout() {
        self.addAnayltics(analyticsParameterItemID: "id-accounttransactions", analyticsParameterItemName: "click_accounttransactions", analyticsParameterContentType: "click_accounttransactions")
        self.title = navTitle
        let strDate = self.changeDateFormate(date: startDate)
        let enDate = self.changeDateFormate(date: endDate)
        self.lblDate.text = "\(strDate) - \(enDate)"
        self.changeColor(image: UIImage(named: "dropdown_arrow_s_10") ?? UIImage(), color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), button: btnDateSelect)
        let request = ExpenseList.Request(startDate: self.startDate, endDate: self.endDate, searchKeyword: "", instutionId: self.instId, accountId: self.accountId, pageIndex: self.pageIndex)
        interactor?.getAllData(request: request, showLoader: true)
        tblView.keyboardDismissMode = .onDrag
        
        if instId == "" {
            self.lblReceiptType.text = "Saved Receipts"
            self.btnFilter.isHidden = true
        }else {
            self.lblReceiptType.text = "All Transactions"
            self.btnFilter.isHidden = false
        }
        tblView.cr.addHeadRefresh(animator: NormalHeaderAnimator(frame: tblView.frame)) {[weak self] in
            if self?.internetAvailable() ?? false {
                self?.pageIndex = 1
                self?.pullRefresh = true
                let request = ExpenseList.Request(startDate: self?.startDate ?? "", endDate: self?.endDate ?? "", searchKeyword: self?.serachBar.text ?? "", instutionId: self?.instId ?? "", accountId: self?.accountId ?? "", pageIndex: self?.pageIndex ?? 1)
                self?.interactor?.getAllData(request: request, showLoader: false)
            }else {
                self?.tblView.cr.endHeaderRefresh()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(Action(n:)), name: NSNotification.Name.init("ChangeTax"), object: nil)
        if #available(iOS 13.0, *) {
           serachBar.searchTextField.backgroundColor = UIColor.white
        }
    }
    
    /// Method used for change
    /// - Parameter date: date
    func changeDateFormate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        let datee = dateFormatterGet.date(from: date)
        return dateFormatterPrint.string(from: datee ?? Date())
    }
    
    //MARK: IBAction
    @IBAction func btnDateSelectAction(_ sender: Any) {
        if let customPopUp = CalendarViewController.instance() {
            customPopUp.updateDateDelegate = self
            self.present(customPopUp, animated: true, completion: nil)
        }
    }
    
    @objc func Action(n: Notification) {
        self.pageIndex = 1
        let request = ExpenseList.Request(startDate: self.startDate , endDate: self.endDate , searchKeyword: self.serachBar.text ?? "", instutionId: self.instId, accountId: self.accountId, pageIndex: self.pageIndex )
        self.interactor?.getAllData(request: request, showLoader: false)
    }
    
    @IBAction func rightBarButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func btnFilterAction(_ sender: Any) {
        if instId != "" {
            if let VC = CategoryViewController.instance() {
                VC.categoryDelegate = self
                VC.instId = self.instId
                VC.lastAccountSelectID = self.accountId
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
}

//MARK: TableView Method
extension ExpenseListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expenseListData.count == 0 {
            return 1
        } else if !self.nextPageAvailable && expenseListData.count > 0 {
            return expenseListData.count
        }else {
            return expenseListData.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if expenseListData.count == 0 {
            let noRecordCell = tableView.dequeueReusableCell(withIdentifier: NoRecordCell.cellId, for: indexPath) as! NoRecordCell
            noRecordCell.lblMessage.text = message
            return noRecordCell
        } else {
            if indexPath.row ==  expenseListData.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "expenseList", for: indexPath) as! ExpenseListTableViewCell
                cell.setDate(data: expenseListData[indexPath.row],instId: self.instId)
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.instId == "" {
            if let VC = CashTransactionViewController.instance() {
                VC.transId = expenseListData[indexPath.row].t_transaction_id ?? ""
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else {
            if let VC = BankTransactionViewController.instance() {
                VC.transId = expenseListData[indexPath.row].t_transaction_id ?? ""
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.expenseListData.count && nextPageAvailable && !dataLoading && expenseListData.count > 0 {
            self.dataLoading = true
            self.pageIndex += 1
            let request = ExpenseList.Request(startDate: self.startDate , endDate: self.endDate , searchKeyword: self.serachBar.text ?? "", instutionId: self.instId, accountId: self.accountId, pageIndex: self.pageIndex )
            self.interactor?.getAllData(request: request, showLoader: false)
            
        }
    }
}

//MARK: SearchBar Methods
extension ExpenseListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.serachBar.endEditing(true)
        self.pageIndex = 1
        let request = ExpenseList.Request(startDate: self.startDate, endDate: self.endDate, searchKeyword: (self.serachBar.text)?.trimmingCharacters(in: .whitespaces) ?? "", instutionId: self.instId, accountId: self.accountId, pageIndex: self.pageIndex)
        interactor?.getAllData(request: request, showLoader: true)
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.pageIndex = 1
            let request = ExpenseList.Request(startDate: self.startDate, endDate: self.endDate, searchKeyword: (self.serachBar.text)?.trimmingCharacters(in: .whitespaces) ?? "", instutionId: self.instId, accountId: self.accountId, pageIndex: self.pageIndex)
            interactor?.getAllData(request: request, showLoader: true)
        }
    }
}

//MARK:  Custom Protocol to select category
extension ExpenseListViewController: SelectCategory {
    
    func setCategory(accountId: String,accountName: String) {
        self.accountId = accountId
        
        self.lblReceiptType.text = "\(accountName)"
        self.btnFilter.isHidden = false
        
        if self.accountId == "" {
            self.imGFilter.isHidden = true
        }else {
            self.imGFilter.isHidden = false
        }
        
        self.pageIndex = 1
        let request = ExpenseList.Request(startDate: self.startDate, endDate: self.endDate, searchKeyword: "", instutionId: self.instId, accountId: self.accountId, pageIndex: self.pageIndex)
        interactor?.getAllData(request: request, showLoader: true)
    }
}

//MARK:  Custom Protocol to update home data
extension ExpenseListViewController: UpdateHomeDate {
    func updateDate(startDate: String, endDate: String) {
        if self.internetAvailable() {
            self.startDate = startDate
            self.endDate = endDate
            self.pageIndex = 1
            let request = ExpenseList.Request(startDate: self.startDate, endDate: self.endDate, searchKeyword: self.serachBar.text ?? "" , instutionId: self.instId, accountId: self.accountId, pageIndex: self.pageIndex)
            interactor?.getAllData(request: request, showLoader: true)
            self.lblDate.text = "\(self.changeDateFormate(date: startDate)) - \(self.changeDateFormate(date: endDate))"
        }
    }
}

//MARK: API Response
extension ExpenseListViewController: ExpenseListDisplayLogic {
    
    func didReceiveAllData(response: ExpenseList.ViewModel?, message: String, success: String,currPage: String, nextPage: Bool) {
        tblView.cr.endHeaderRefresh()
        if success == "1" {
            self.message = ""
            self.serachBar.endEditing(true)
            self.nextPageAvailable = nextPage
            self.dataLoading = false
            self.pageIndex = Int(currPage) ?? 1
            
            if let data = response {
                if !pullRefresh {
                    if let VC = ExpenseListPopUpViewController.instance(){
                        VC.modalPresentationStyle = .overCurrentContext
                        self.present(VC, animated: false, completion: nil)
                    }
                }
                
                if let total = data.totalAmount?.first {
                    self.lblTaxApplied.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(total.totalTaxAmount ?? "0.00"))"
                    self.lblTotalAmount.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(total.totalTransactionAmount ?? "0.00"))"
                }
                if let inst = data.transctionData {
                    if currPage == "1" {
                        self.expenseListData = inst
                    }else {
                        self.expenseListData.append(contentsOf: inst)
                    }
                    self.tblView.reloadData()
                }
            }
        } else {
            self.message = message
            self.lblTaxApplied.text = "$0.00"
            self.lblTotalAmount.text = "$0.00"
            self.expenseListData.removeAll()
            self.tblView.reloadData()
        }
    }
    
    func didReceiveAddTipResponse(message: String, success: String) {
        if success == "1" {
            
        } else {
            showTopMessage(message: message, type: .Error)
        }
    }

}
