//
//  HomeViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.

import UIKit
import CRRefresh
import NotificationCenter
import LinkKit

/// Protocol for presenting response
protocol HomeDisplayLogic: class {
    func didReceiveAllData(response: Home.ViewModel?, message: String, success: String)
    func didReceiveAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String)
    func didReceiveFetchTransactionResponse(message: String, success: String)
    func didReceiveGenerateToken(response: GeneratePublicToken.ViewModel?, message: String, success: String)
    func didReceiveUpdateErrorLog( message: String, success: String)
}

protocol UpdateHomeDate {
    func updateDate(startDate: String, endDate: String)
}

/// This class is used to display home screen of the app.
class HomeViewController: BaseViewControllerWithAd, LinkOAuthHandling {
    
    var linkHandler: Handler?
    
    /// Interactor for API Call
    var interactor: HomeBusinessLogic?
    var profileInteractor: MyProfileBusinessLogic?
    
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    //MARK: IBOUtlet Constant
    @IBOutlet weak var lblTaxApplied: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var clnView: UICollectionView!
    @IBOutlet weak var viewTaxApplied: UIView!
    @IBOutlet weak var viewTotalAmount: UIView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewAd: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnChangeDate: UIButton!
    
    var transactionData = [Home.ViewModel.InstitutionDetail]()
    var startDate = ""
    var endDate = ""
    var currYear = ""
    
    var instutionId = ""
    
    var subStatus = false
    
    // MARK: Object lifecycle
    /// Override method to initialize with nib
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib name
    ///   - nibBundleOrNil: Bundle in which nib is present
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    /// Decoder
    ///
    /// - Parameter aDecoder: Decoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAnayltics(analyticsParameterItemID: "id-homescreen", analyticsParameterItemName: "click_homescreen", analyticsParameterContentType: "click_homescreen")
        
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false)
        self.clnView.delegate = self
        self.clnView.dataSource = self
        
        let calendar = Calendar.current
        self.currYear = String(calendar.component(.year, from: Date()) - 1)
        
        let date = self.getdates(year: self.currYear)
        let request = Home.Request(startDate: date.0, endDate: date.1)
        self.interactor?.getAllData(request: request, showLoader: true)
        self.startDate = date.0
        self.endDate = date.1
        
        let strDate = self.changeDateFormate(date: date.0)
        let enDate = self.changeDateFormate(date: date.1)
        self.lblDate.text = "\(strDate) - \(enDate)"
        
        let viewTitle = UIView()
        let imaage = UIImageView(frame: viewTitle.frame)
        imaage.image = UIImage(named: "img_topicon")
        imaage.contentMode = .center
        viewTitle.addSubview(imaage)
        self.navigationItem.titleView = viewTitle
        
        NotificationCenter.default.addObserver(self, selector: #selector(Action(n:)), name: NSNotification.Name.init("AddBank"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActionAddReceipt(n:)), name: NSNotification.Name.init("AddReceipt"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActionAddTax(n:)), name: NSNotification.Name.init("ChangeTax"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActionHome(n:)), name: NSNotification.Name.init("CallFromPlaidAPIHome"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneratePublicTokenAction(n:)), name: NSNotification.Name.init("GeneratePublicToken"), object: nil)
        
        self.changeColor(image: UIImage(named: "dropdown_arrow_s_10") ?? UIImage(), color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), button: btnChangeDate)
        
        clnView.cr.addHeadRefresh(animator: NormalHeaderAnimator(frame: clnView.frame)) {[weak self] in
            if self?.internetAvailable() ?? false {
                let request = Home.Request(startDate: self?.startDate ?? "", endDate: self?.endDate ?? "")
                self?.interactor?.getAllData(request: request, showLoader: false)
            }else {
                self?.clnView.cr.endHeaderRefresh()
            }
            
        }
        clnView.alwaysBounceVertical = true
        
        if UserDefaultsManager.tutorialFinish != "Yes" {
            if let VC = WelcomeViewController.instance() {
                VC.modalPresentationStyle = .fullScreen
                self.present(VC, animated: true, completion: nil)
            }
        }

        subStatus = UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false
    }
    
    //MARK: IBAction
    @objc func GeneratePublicTokenAction(n: Notification) {

        let request = UpdateErrorLog.Request(institutionId:  self.instutionId , status: "Resolved", errorCode: "", additionalInfo: "")
        interactor?.updateErrorLog(request: request)
        self.instutionId = ""
        
    }
    
    
    @objc func ActionHome(n: Notification) {
        let publicToken = n.userInfo?["publicToken"] as! String
        let instName = n.userInfo?["instName"] as! String
        let insId = n.userInfo?["insId"] as! String
        let request = AddBankAccount.Request(publicToken: publicToken, institutionName: instName, institutionId: insId)
        self.interactor?.addAccount(request: request)
    }
    
    /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAddMobView(viewAdd: self.viewAd)
    }
    
    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false)
        
        if subStatus != (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false) {
            subStatus = (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false)
            let request = Home.Request(startDate: self.startDate, endDate: self.endDate)
            self.interactor?.getAllData(request: request, showLoader: false)
        }
    }
    
    // MARK: Class Instance
    class func instance() -> HomeViewController? {
        return StoryBoard.Home.board.instantiateViewController(withIdentifier: AppClass.HomeVC.rawValue) as? HomeViewController
    }
    
    /// Method used to get date
    /// - Parameter year: year
    func getdates(year: String) -> (String, String) {
        let startdate = "\(year)-01-01"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        dateFormatterGet.string(from: Date())
        let endDate = dateFormatterGet.string(from: Date())
        return (startdate, endDate)
    }
    
    /**
     This method called to change date formate.
     */
    func changeDateFormate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        let datee = dateFormatterGet.date(from: date)
        return dateFormatterPrint.string(from: datee ?? Date())
    }
    
    @objc func ActionAddReceipt(n: Notification) {
        let request = Home.Request(startDate: self.startDate, endDate: self.endDate)
        self.interactor?.getAllData(request: request, showLoader: false)
    }
    
    @objc func Action(n: Notification) {
        var loader = false
        if UIViewController.topViewController(withRootViewController:GlobalUtility.getRootViewController()) is HomeViewController {
            loader = true
        }
       
        let date = self.getdates(year: self.currYear)
        let request = Home.Request(startDate: date.0, endDate: date.1)
        self.interactor?.getAllData(request: request, showLoader: loader)
    }
    
    @objc func ActionAddTax(n: Notification) {
        let request = Home.Request(startDate: startDate, endDate: endDate)
        self.interactor?.getAllData(request: request, showLoader: false)
    }
    
    @IBAction func btncalenderOpenTapped(_ sender: Any) {
        self.addAnayltics(analyticsParameterItemID: "id-datefilter", analyticsParameterItemName: "click_datefilter", analyticsParameterContentType: "click_datefilter")
        if let customPopUp = CalendarViewController.instance() {
            customPopUp.isFrom = "Home"
            customPopUp.updateDateDelegate = self
            self.present(customPopUp, animated: true, completion: nil)
        }
        
    }
    
}
//MARK: CollectionView Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactionData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.cellID, for: indexPath) as! HomeCell
        if indexPath.row == 0 {
            cell.viewAddAccount.isHidden = false
        }else {
            cell.viewAddAccount.isHidden = true
            cell.setData(data: transactionData[indexPath.row - 1])
           if self.internetAvailable() {
                cell.btnErrorClouser = {
                    if self.transactionData[indexPath.row - 1].loginRequired ?? "" == "no" {
                        self.displayAlertSingleOption(msg: self.transactionData[indexPath.row - 1].errorMessage ?? "", ok: "Ok", okAction: nil)
                    }else {
                        self.displayAlert(msg: self.transactionData[indexPath.row - 1].errorMessage ?? "", ok: "Login", cancel: "Ok", okAction: {
                            let request = GeneratePublicToken.Request(institutionId: self.transactionData[indexPath.row - 1].uniqueInstitutionId ?? "")
                            self.interactor?.generatePublicToken(request: request)
                        }, cancelAction: nil)
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var frame = clnView.frame
        frame.size.width = (frame.width)/2
        frame.size.height = ((frame.width)*(55/95))
        return frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if self.internetAvailable(){
                self.addAnayltics(analyticsParameterItemID: "id-addbank", analyticsParameterItemName: "click_addbank", analyticsParameterContentType: "click_addbank")
                
                if (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false) {
                    
                    self.displayAlert(msg: "Please make sure to enter all the required information before submitting the information to add the bank account. \nNote: Some bank accounts ask for three fields of information. Make sure you have entered the information in all the fields before submitting.", ok: "OK", cancel: "Cancel", okAction: {
                        PlaidAPICall.sharedInstance.isFrom = "Home"
                        PlaidAPICall.sharedInstance.pladeApiConfiguration()
                    }, cancelAction: nil)
                }else {
                    if let VC = SubscriptionViewController.instance() {
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                }
                
            }
        } else {
            if let VC = ExpenseListViewController.instance() {
                VC.navTitle = transactionData[indexPath.row - 1].institutionName ?? ""
                VC.startDate = self.startDate
                VC.endDate = self.endDate
                VC.instId = transactionData[indexPath.row - 1].institutionID ?? ""
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
    }
}

//MARK: API Response
extension HomeViewController: HomeDisplayLogic {
    func didReceiveAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let response = response {
                GlobalUtility.showHud(message: "Please wait, while we are fetching your transactions first time.")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                    let req = FetchTransaction.Request(accessToken: response.institutionId ?? "")
                    self.interactor?.fetchTrnasaction(request: req)
                }
                WhiteLabelSessionHandler.shared.addCount = WhiteLabelSessionHandler.shared.addCount + 1
            }
            showTopMessage(message: message, type: .Success)
        } else {
            showTopMessage(message: message, type: .Error)
        }

    }
    
    func didReceiveFetchTransactionResponse(message: String, success: String) {
        if success == "1" {
            NotificationCenter.default.post(name: NSNotification.Name("CallFromHomeAPI"), object: nil)
            let request = Home.Request(startDate: self.startDate, endDate: self.endDate)
            self.interactor?.getAllData(request: request, showLoader: true)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveAllData(response: Home.ViewModel?, message: String, success: String) {
        self.clnView.cr.endHeaderRefresh()
        if success == "1" {
            if let data = response {
                if let total = data.totalAmount?.first {
                    self.lblTaxApplied.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(total.totalTaxAmount ?? "0.00"))"
                    self.lblTotalAmount.text = "\(GlobalUtility.shared.roundOffTextTwoDigit(total.totalTransactionAmount ?? "0.00"))"
                    
                }
                if let inst = data.getInstitutionTotalAmount {
                    self.transactionData = inst
                    self.clnView.reloadData()
                }
            }
        } else {
            showTopMessage(message: message, type: .Error)
            self.lblTaxApplied.text = "$0.00"
            self.lblTotalAmount.text = "$0.00"
            self.transactionData.removeAll()
            self.clnView.reloadData()
        }
    }
    
    func didReceiveGenerateToken(response: GeneratePublicToken.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                self.instutionId = data.userInstitutionId ?? ""
                PlaidAPICall.sharedInstance.isFrom = "GeneratePublicToken"
                //PlaidAPICall.sharedInstance.update(publicToken: data.publicToken ?? "")
            }
        }else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveUpdateErrorLog(message: String, success: String) {
        if success == "1" {
            self.showTopMessage(message: message, type: .Success)
            let request = Home.Request(startDate: self.startDate, endDate: self.endDate)
            self.interactor?.getAllData(request: request, showLoader: false)
        }else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}

//MARK: Custom Protocol UpdateHome data
extension HomeViewController: UpdateHomeDate {
    func updateDate(startDate: String, endDate: String) {
        if self.internetAvailable() {
            if startDate == "" && endDate == "" {
                let calendar = Calendar.current
                self.currYear = String(calendar.component(.year, from: Date()) - 1)
                let date = self.getdates(year: self.currYear)
                let request = Home.Request(startDate: date.0, endDate: date.1)
                self.interactor?.getAllData(request: request, showLoader: true)
                self.startDate = date.0
                self.endDate = date.1
                let strDate = self.changeDateFormate(date: date.0)
                let enDate = self.changeDateFormate(date: date.1)
                self.lblDate.text = "\(strDate) - \(enDate)"
            }else {
                let request = Home.Request(startDate: startDate, endDate: endDate)
                self.interactor?.getAllData(request: request, showLoader: true)
                self.startDate = startDate
                self.endDate = endDate
                self.lblDate.text = "\(self.changeDateFormate(date: startDate)) - \(self.changeDateFormate(date: endDate))"
            }
        }
    }
}
