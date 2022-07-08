//
//  LoginEmailViewController.swift
//  WhiteLabel
//
//  Created by hb on 09/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol for presenting response
protocol LoginEmailDisplayLogic: class {
    /// Did Receive Login API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveLoginResponse(response: Login.ViewModel?, message: String, success: String)
}

/// This class is used for login action of user. Login can be done using phone number and password.
class LoginEmailViewController: BaseViewController {
    /// Interactor for API Call
    var interactor: LoginEmailBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & LoginEmailRoutingLogic & LoginEmailDataPassing)?
    
    @IBOutlet weak var txtFieldEmail: CustomTextField!
    @IBOutlet weak var btnLogin: WLButton!
    @IBOutlet weak var txtFieldPassword: CustomTextField!
    
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
    
    /// Instance
    ///
    /// - Returns: LoginEmailViewController
    class func instance() -> LoginEmailViewController? {
        return StoryBoard.LoginEmail.board.instantiateViewController(withIdentifier: AppClass.LoginEmailVC.rawValue) as? LoginEmailViewController
    }
    
    // MARK: Setup
    
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = LoginEmailInteractor()
        let presenter = LoginEmailPresenter()
        let router = LoginEmailRouter()
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
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // SetUpLayout initial UI setup
    func setUpLayout() {
        self.navigationItem.title = AlertMessage.loginTitle
    }
    
    /// Validiate all fields and call login api
    func validateFields() {
        guard self.internetAvailable() else {
            return
        }
        do {
            let email = try txtFieldEmail.validatedText(validationType: ValidatorType.email)
            let password = try txtFieldPassword.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requirePassword))
             self.interactor?.loginWithEmail(request: LoginEmailModel.Request(email: email, password: password))
        } catch(let error) {
            self.showTopMessage(message: (error as? ValidationError)?.message, type: .Error)
        }
    }
    
    // MARK: WLButton tap actions
    
    /// Forgot Password Tap Action
    ///
    /// - Parameter sender: WLButton
    @IBAction func forgotPasswordAction(_ sender: Any) {
        if let forgotPassword = ForgotPasswordEmailViewController.instance() {
            self.navigationController?.pushViewController(forgotPassword, animated: true)
        }
    }
    
    /// Login Button Tap Action
    ///
    /// - Parameter sender: WLButton
    @IBAction func loginAction(_ sender: Any) {
        validateFields()
    }
    
    /// Create new account or Signup
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnCreateNowTapped(_ sender: Any) {
        if let signUpVC = SignUpViewController.instance() {
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    /// Skip to main home screen
    ///
    /// - Parameter sender: WLButton
    @IBAction func skipAction(_ sender: Any) {
        AppConstants.isLoginSkipped = true
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
            GlobalUtility.setRootViewController(viewController: tab)
        }
    }
}

// MARK: - Login Email API Response
extension LoginEmailViewController: LoginEmailDisplayLogic {
    /// Did Receive Login API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveLoginResponse(response: Login.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                UserDefaultsManager.setLoggedUserDetails(userDetail: data)
                AppConstants.isLoginSkipped = false
                router?.redirectToHome()
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
