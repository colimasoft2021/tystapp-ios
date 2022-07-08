//
//  MyProfileViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.

import UIKit
import InitialsImageView
import LinkKit
import CRRefresh

/// Protocol for presenting response
protocol MyProfileDisplayLogic: class {
    
    func didReceiveAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String)
    func didReceiveRemoveAccountResponse(message: String, success: String)
    func didReceiveUserInstitutionsResponse(response: [AddBankAccount.ViewModel]?, message: String, success: String)
    /// Did Receive fetchResponse
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveFetchTransactionResponse(message: String, success: String)
}

/// This class is used to display logged in user's profile view.
class MyProfileViewController: BaseViewControllerWithAd, LinkOAuthHandling {
    
    // MARK: IBOutlet
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewProfileBg: UIView!
    @IBOutlet weak var viewAd: UIView!
    @IBOutlet weak var clnView: UICollectionView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    var linkHandler: Handler?
    
    /// Interactor for API Call
    var interactor: MyProfileBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & MyProfileRoutingLogic & MyProfileDataPassing)?
    
    var instituteData = [AddBankAccount.ViewModel]()
    var removedIndex: Int?
    
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
        let interactor = MyProfileInteractor()
        let presenter = MyProfilePresenter()
        let router = MyProfileRouter()
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
        setUpLayout()
    }

    
    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUserData()
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false)
        
        if subStatus != (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false) {
            subStatus = (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false)
            interactor?.userInstitution(loader: false)
        }
    }
    
    /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAddMobView(viewAdd: self.viewAd)
    }
    
    // MARK: Class Methods
    // SetUpLayout initial
    func setUpLayout() {
        self.navigationItem.title = AlertMessage.myProfileTitle
       // viewProfileBg.addCircularShadow(5)
        viewProfileBg.addShadow(ofColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        clnView.delegate = self
        clnView.dataSource = self
        
        interactor?.userInstitution(loader: true)
        
        clnView.cr.addHeadRefresh(animator: NormalHeaderAnimator(frame: clnView.frame)) {[weak self] in
            if self?.internetAvailable() ?? false {
               self?.interactor?.userInstitution(loader: false)
            }else {
                self?.clnView.cr.endHeaderRefresh()
            }
        }
        
        clnView.alwaysBounceVertical = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(Action(n:)), name: NSNotification.Name.init("CallFromPlaidAPI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActionHome(n:)), name: NSNotification.Name.init("CallFromHomeAPI"), object: nil)
        
        subStatus = UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false
    }
    
    @objc func Action(n: Notification) {
        print("CALL")
        let publicToken = n.userInfo?["publicToken"] as! String
        let instName = n.userInfo?["instName"] as! String
        let insId = n.userInfo?["insId"] as! String
        let request = AddBankAccount.Request(publicToken: publicToken, institutionName: instName, institutionId: insId)
        self.interactor?.addAccount(request: request)
    }
    
    @objc func ActionHome(n: Notification) {
        interactor?.userInstitution(loader: false)
    }
    
    
    //Set user login details
    func setUserData() {
        let logindata = UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0]
        self.lblFullName.text = (logindata?.firstName ?? "") + " " + (logindata?.lastName ?? "")
        self.lblEmail.text = logindata?.email
        self.lblPhoneNumber.text = (logindata?.mobileNo ?? "") .toPhoneNumber()
        if logindata?.mobileNo == "" {
            self.lblPhoneNumber.isHidden = true
        }else {
            self.lblPhoneNumber.isHidden = false
        }
        viewProfileBg.layoutIfNeeded()
    }
    
//    func pladeApiConfiguration() {
//        #if USE_CUSTOM_CONFIG
//        presentPlaidLinkWithCustomConfiguration()
//        #else
//        presentPlaidLinkWithSharedConfiguration()
//        #endif
//    }
//
//    func handleSuccessWithToken(_ publicToken: String, metadata: [String : Any]?) {
//        presentAlertViewWithTitle("Success", message: "token: \(publicToken)\nmetadata: \(metadata ?? [:])")
//    }
//
//    func handleError(_ error: Error, metadata: [String : Any]?) {
//        presentAlertViewWithTitle("Failure", message: "error: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
//    }
//
//    func handleExitWithMetadata(_ metadata: [String : Any]?) {
//        print("EXIT metadata: \(metadata ?? [:])")
//    }
//
//    func presentAlertViewWithTitle(_ title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//
//    // MARK: Plaid Link setup with shared configuration from Info.plist
//    func presentPlaidLinkWithSharedConfiguration() {
//        // <!-- SMARTDOWN_PRESENT_SHARED -->
//        // With shared configuration from Info.plist
//        let linkViewDelegate = self
//        let linkViewController = PLKPlaidLinkViewController(delegate: linkViewDelegate)
//        if (UI_USER_INTERFACE_IDIOM() == .pad) {
//            linkViewController.modalPresentationStyle = .formSheet
//        }
//        present(linkViewController, animated: true)
//        // <!-- SMARTDOWN_PRESENT_SHARED -->
//    }
//
//    // MARK: Plaid Link setup with custom configuration
//    func presentPlaidLinkWithCustomConfiguration() {
//        // <!-- SMARTDOWN_PRESENT_CUSTOM -->
//        // With custom configuration
//        let linkConfiguration = PLKConfiguration(key: AppConstants.plaidPublicKey, env: .sandbox, product: .transactions)
//
////        let linkConfiguration2 = PLKConfiguration(key: AppConstants.plaidPublicKey, env: .sandbox, product: .transactions, selectAccount: false, longtailAuth: true, apiVersion: .PLKAPILatest)
//
//
//        linkConfiguration.clientName = "Link Demo"
//        let linkViewDelegate = self
//        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
//        if (UI_USER_INTERFACE_IDIOM() == .pad) {
//            linkViewController.modalPresentationStyle = .formSheet
//        }
//        present(linkViewController, animated: true)
//        // <!-- SMARTDOWN_PRESENT_CUSTOM -->
//    }
//
//    // MARK: Start Plaid Link in update mode
//    func presentPlaidLinkInUpdateMode() {
//        // <!-- SMARTDOWN_UPDATE_MODE -->
//        let linkViewDelegate = self
//        let linkViewController = PLKPlaidLinkViewController(publicToken: "", delegate: linkViewDelegate)
//        if (UI_USER_INTERFACE_IDIOM() == .pad) {
//            linkViewController.modalPresentationStyle = .formSheet
//        }
//        present(linkViewController, animated: true)
//        // <!-- SMARTDOWN_UPDATE_MODE -->
//    }
    
    /// Open user profile in full screen
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnImagedetailsAction(_ sender: Any) {
//        let logindata = UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0]
//        if let img = logindata?.userProfile, img != "" {
//            if let customPopUp = ImageDetailsViewController.instance() {
//                customPopUp.imgStr = img
//                self.present(customPopUp, animated: true, completion: nil)
//            }
//        }
    }
    
    @IBAction func btnEditProfile(_ sender: Any) {
        if let editProfileVC = EditProfileViewController.instance() {
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    @IBAction func btnAddAccountTapAction(_ sender: UIButton) {
      //  self.pladeApiConfiguration()
    }
    
}

// MARK: - PLKPlaidLinkViewDelegate Protocol
// <!-- SMARTDOWN_PROTOCOL -->
//extension MyProfileViewController: PLKPlaidLinkViewDelegate {
//    // <!-- SMARTDOWN_PROTOCOL --
//
//
//    // <!-- SMARTDOWN_DELEGATE_SUCCESS -->
//    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
//        dismiss(animated: true) {
//            // Handle success, e.g. by storing publicToken with your service
//            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")
//            //            self.handleSuccessWithToken(publicToken, metadata: metadata)
//            var insId = ""
//            var instName = ""
//            if let data = metadata {
//                if let institute = data["institution"] as? [String:Any] {
//                    instName = (institute["name"] ?? "") as! String
//                    insId = (institute["institution_id"] ?? "") as! String
//                }
//            }
//
//            let request = AddBankAccount.Request(publicToken: publicToken, institutionName: instName, institutionId: insId)
//            self.interactor?.addAccount(request: request)
//        }
//    }
//    // <!-- SMARTDOWN_DELEGATE_SUCCESS -->
//
//    // <!-- SMARTDOWN_DELEGATE_EXIT -->
//    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
//        dismiss(animated: true) {
//            if let error = error {
//                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
//                self.handleError(error, metadata: metadata)
//            }
//            else {
//                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
//                self.handleExitWithMetadata(metadata)
//            }
//        }
//    }
//    // <!-- SMARTDOWN_DELEGATE_EXIT -->
//
//    // <!-- SMARTDOWN_DELEGATE_EVENT -->
//    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didHandleEvent event: String, metadata: [String : Any]?) {
//        NSLog("Link event: \(event)\nmetadata: \(metadata ?? [:])")
//    }
//}


extension MyProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instituteData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankListCell.cellId, for: indexPath) as! BankListCell
        let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddBankCell.cellId, for: indexPath) as! AddBankCell
        
        if (indexPath.row != 0) {
            cell.confirgurCellData(data: instituteData[indexPath.row-1])
        }
        
        cell.removeAction = {
            if (indexPath.row != 0) {
                 self.addAnayltics(analyticsParameterItemID: "id-deletebank", analyticsParameterItemName: "click_deletebank", analyticsParameterContentType: "click_deletebank")
                self.displayAlert(msg: "Are you sure you want to unlink this bank account in TYST? This will remove all transaction records from TYST.", ok: AlertMessage.ok, cancel: AlertMessage.cancel, okAction: {
                    self.removedIndex = indexPath.row - 1
                    let request = RemoveAccount.Request(accountId: self.instituteData[self.removedIndex ?? 0].institutionId ?? "")
                    self.interactor?.removeAccount(request: request)
                }, cancelAction: nil)
            }
        }
        
        addCell.addAction = {
            if self.internetAvailable(){
                self.addAnayltics(analyticsParameterItemID: "id-addbank", analyticsParameterItemName: "click_addbank", analyticsParameterContentType: "click_addbank")
                
                if (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false) {
                    self.displayAlert(msg: "Please make sure to enter all the required information before submitting the information to add the bank account. \nNote: Some bank accounts ask for three fields of information. Make sure you have entered the information in all the fields before submitting.", ok: "OK", cancel: "Cancel", okAction: {
                        PlaidAPICall.sharedInstance.isFrom = ""
                        PlaidAPICall.sharedInstance.pladeApiConfiguration()
                    }, cancelAction: nil)
                }else {
                    if let VC = SubscriptionViewController.instance() {
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                }
                
            }
        }
        
        return (indexPath.row == 0) ? addCell:cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var frame = clnView.frame
        frame.size.width = (frame.width)/2
        frame.size.height = ((frame.width)*(55/81)) + 10
        return frame.size
    }
    
}

/// Protocol for presenting response
extension MyProfileViewController : MyProfileDisplayLogic {
    func didReceiveUserInstitutionsResponse(response: [AddBankAccount.ViewModel]?, message: String, success: String) {
        self.clnView.cr.endHeaderRefresh()
        if success == "1" {
        if let response = response {
            self.instituteData = response
                self.clnView.reloadData()
            }
        }else {
            if !self.internetAvailable() {
                showTopMessage(message: message, type: .Error)
            }
        }
    }
    
    func didReceiveAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let response = response {
                //self.instituteData.append(response)
                self.instituteData.insert(response, at:0)
                let user = UserDefaultsManager.getLoggedUserDetails()
                user?.institution = self.instituteData
                UserDefaultsManager.setLoggedUserDetails(userDetail: user!)
                self.clnView.reloadData()
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
    
    func didReceiveRemoveAccountResponse(message: String, success: String) {
        if success == "1" {
            if let index = self.removedIndex {
                self.instituteData.remove(at: index)
                self.clnView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name("AddBank"), object: nil)
            }
            showTopMessage(message: message, type: .Success)
            WhiteLabelSessionHandler.shared.addCount = WhiteLabelSessionHandler.shared.addCount + 1
        } else {
            showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive fetchResponse
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveFetchTransactionResponse(message: String, success: String) {
        if success == "1" {
            NotificationCenter.default.post(name: NSNotification.Name("AddBank"), object: nil)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
