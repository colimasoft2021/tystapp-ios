//
//  CategoryListViewController.swift
//  Tyst
//
//  Created by hb on 30/03/20.
//  Copyright (c) 2020 hb. All rights reserved.


import UIKit

protocol CategoryListDisplayLogic: class {
    func didReceivePresentCategoryList(response: [CategoryList.ViewModel]?, message: String, success: String)
}

class CategoryListViewController: BaseViewController {
    //MARK: IBOutlet Constants
    
    var interactor: CategoryListBusinessLogic?
    var router: (NSObjectProtocol & CategoryListRoutingLogic & CategoryListDataPassing)?
    var category = [CategoryList.ViewModel]()
    
    @IBOutlet weak var tblView: UITableView!
    var chngCtDelegate: ChangeCategory?
    
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
        let interactor = CategoryListInteractor()
        let presenter = CategoryListPresenter()
        let router = CategoryListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    /// - Returns: WelcomeViewController
    class func instance() -> CategoryListViewController? {
        return UIStoryboard(name: "CategoryList", bundle: nil).instantiateViewController(withIdentifier: "CategoryListViewController") as? CategoryListViewController
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getCategory()
        self.navigationItem.title = "Category"
    }
    
}

//MARK: TableView Methods
extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell", for: indexPath) as! CategoryListTableViewCell
        cell.lblTitle.text = category[indexPath.row].category ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.internetAvailable() {
            self.navigationController?.popViewController(animated: true)
            chngCtDelegate?.changeStatus(categoryId: category[indexPath.row].category_id ?? "", categoryName: category[indexPath.row].category ?? "")
        }
    }
    
    
}

//MARK: API Response
extension CategoryListViewController: CategoryListDisplayLogic {
    func didReceivePresentCategoryList(response: [CategoryList.ViewModel]?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                self.category = data
                self.tblView.reloadData()
            }
        }else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
