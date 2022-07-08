//
//  CategoryViewController.swift
//  Tyst
//
//  Created by hb on 28/02/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CategoryDisplayLogic: class {
    func didReceivePresentCategory(response: [Category.ViewModel]?, message: String, success: String)
}

class CategoryViewController: BaseViewController {
    //MARK: IBOutlet Constant
    
    var interactor: CategoryBusinessLogic?
    var router: (NSObjectProtocol & CategoryRoutingLogic & CategoryDataPassing)?
    var instId = ""
    var lastAccountSelectID = ""
    
    var categoryArray = [Category.ViewModel]()
    var filterCategoryArray = [Category.ViewModel]() {
        didSet {
            if filterCategoryArray.count == 0 {
                self.lblNorecord.isHidden = false
            }else {
                self.lblNorecord.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var lblNorecord: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var btnreset: UIButton!
    var categoryDelegate: SelectCategory?
    
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
        let interactor = CategoryInteractor()
        let presenter = CategoryPresenter()
        let router = CategoryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    /// - Returns: WelcomeViewController
    class func instance() -> CategoryViewController? {
        return UIStoryboard(name: "Category", bundle: nil).instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLayout()
    }
    
    // MARK: Class Method
    
    /// Method is used for initial setup of viewcontroller
    func setUpLayout() {
        self.navigationItem.title = "Account"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.btnreset)
        let request = Category.Request(instId: self.instId)
        interactor?.callCategoryAPI(request: request)
        self.tblView.keyboardDismissMode = .onDrag
        if #available(iOS 13.0, *) {
           searchBar.searchTextField.backgroundColor = UIColor.white
        }
    }
    
    //MARK: IBAction
    @IBAction func btnResetAction(_ sender: Any) {
        if internetAvailable() {
            if categoryDelegate != nil {
                categoryDelegate?.setCategory(accountId: "", accountName: "All Transactions")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

//MARK: TableView Methods
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.lblTitle.text = filterCategoryArray[indexPath.row].account_name ?? ""
        if filterCategoryArray[indexPath.row].account_id ?? "" == self.lastAccountSelectID {
            cell.imgSelection.isHidden = false
        }else {
            cell.imgSelection.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if internetAvailable() {
            if categoryDelegate != nil {
                categoryDelegate?.setCategory(accountId: filterCategoryArray[indexPath.row].account_id ?? "", accountName: filterCategoryArray[indexPath.row].account_name ?? "")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

//MARK: SearchBarDelegate Methods
extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            filterCategoryArray = categoryArray
        }else {
            filterCategoryArray = categoryArray.filter{((($0.account_name ?? "")!).lowercased().contains(self.searchBar.text?.lowercased() ?? "") )}
        }
        searchBar.resignFirstResponder()
        tblView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            filterCategoryArray = categoryArray
        } else {
            filterCategoryArray = categoryArray.filter{((($0.account_name ?? "")!).lowercased().contains(self.searchBar.text?.lowercased() ?? "") )}
        }
        tblView.reloadData()
    }
}

//MARK: APIReseponse
extension CategoryViewController: CategoryDisplayLogic {
    func didReceivePresentCategory(response: [Category.ViewModel]?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                self.categoryArray = data
                self.filterCategoryArray = self.categoryArray
                self.tblView.reloadData()
            }
        }else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
