//
//  SplashViewController.swift
//  AppineersWhiteLabel

import UIKit

/// Protocol for presenting response
protocol SplashDisplayLogic: class {
    /// Did Receive OTP Response
    ///
    /// - Parameters:
    ///   - viewModel: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveVersionCheckResponse(viewModel: Splash.ViewModel?, message: String, successCode: String)
}

/// This class is used to launch the app and do operations which need to perform in backgroud during app launch.
class SplashViewController: BaseViewController {
    
    /// Interactor for API Call
    var interactor: SplashBusinessLogic?
    var configModel: Splash.ViewModel?
    private var observer: NSObjectProtocol?
    var isAPiCallFail = false
    
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
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    
    // MARK: ViewLifeCycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { (_) in
            if UIDevice.current.isJailBroken {
                UserDefaultsManager.logoutUser()
                self.showTopMessage(message: AlertMessage.jailBroken, type: .Error)
            } else {
                if self.isAPiCallFail {
                    self.interactor?.callVersionCheckAPI()
                }
            }
            
        })
        
        if UIDevice.current.isJailBroken {
            UserDefaultsManager.logoutUser()
            self.showTopMessage(message: AlertMessage.jailBroken, type: .Error)
        } else {
            self.interactor?.callVersionCheckAPI()
        }
        
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setViewController() {
        if (UserDefaultsManager.getLoggedUserDetails() != nil) {
            if configModel?.termsConditionUpdate  == "1" {
                if let staticPageVC = StaticPageViewController.instance() {
                    let aNav = NavController(rootViewController: staticPageVC)
                    staticPageVC.showAgreeBtn = true
                    staticPageVC.isFrom = StaticPageCode.termsCondition.rawValue
                    aNav.modalPresentationStyle = .fullScreen
                    staticPageVC.updateCompletion = {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                            self.checkPrivacyPolicy()
                        }
                    }
                    self.present(aNav, animated: true, completion: nil)
                }
            } else {
                self.checkPrivacyPolicy()
            }
        } else {
            self.pushToMainScreen()
        }
    }
    
    /// Check Privacy Policy version
    func checkPrivacyPolicy() {
        if configModel?.privacyPolicyUpdate  == "1" {
            if let staticPageVC = StaticPageViewController.instance() {
                let aNav = NavController(rootViewController: staticPageVC)
                staticPageVC.showAgreeBtn = true
                staticPageVC.isFrom = StaticPageCode.privacyPolicy.rawValue
                aNav.modalPresentationStyle = .fullScreen
                staticPageVC.updateCompletion = {
                    self.pushToMainScreen()
                }
                self.present(aNav, animated: true, completion: nil)
            }
        } else {
            self.pushToMainScreen()
        }
    }
    
    
    func pushToMainScreen() {
        if (UserDefaultsManager.getLoggedUserDetails() != nil) {
            // MARK: - Home screen setup autologin
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
                AppConstants.appDelegate.window?.rootViewController = tab
            }
        } else {
            GlobalUtility.redirectToLogin()
        }
        
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    
    func redirectToAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - For Splash API Reponse
extension SplashViewController: SplashDisplayLogic {
    /// Did Receive OTP Response
    ///
    /// - Parameters:
    ///   - viewModel: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveVersionCheckResponse(viewModel: Splash.ViewModel?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = viewModel {
                //                let aVersion : Double = Double(AppInfo.kAppVersion) ?? 1.0
                //                let aIOSVersion : Double = Double(data.iosVersion ?? "1.0") ?? 1.0
                
                self.configModel = data
                let aVersion  = AppInfo.kAppVersion
                let aIOSVersion = data.iosVersion ?? "1.0"
                AppConstants.taxPercentage = data.taxPercentage ?? "0.0"
                
                if data.versionUpdateCheck == "1" {
                    if aVersion < aIOSVersion {
                        self.displayAlert(msg: data.alertMessage, ok: AlertMessage.update, cancel: AlertMessage.notNow, okAction: {
                            self.redirectToAppStore()
                            if data.versionUpdateOptional == "1" {
                                self.setViewController()
                            }
                        }, cancelAction: {
                            if data.versionUpdateOptional == "1" {
                                self.setViewController()
                            }
                        })
                    } else {
                        self.setViewController()
                    }
                } else {
                    self.setViewController()
                }
            }
        } else {
            self.isAPiCallFail = true
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
