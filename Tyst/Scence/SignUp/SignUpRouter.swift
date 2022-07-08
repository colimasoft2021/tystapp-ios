//
//  SignUpRouter.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.

import UIKit

/// Protocol for sign up routing
protocol SignUpRoutingLogic {
    func redirectToHome()
}

/// Protocol for signup data passing
protocol SignUpDataPassing {
    var dataStore: SignUpDataStore? { get }
}

/// Class for sign up router
class SignUpRouter: NSObject, SignUpRoutingLogic, SignUpDataPassing {
    
    /// Viewcontroller instance
    weak var viewController: SignUpViewController?
    /// Datastore instance
    var dataStore: SignUpDataStore?
    
    
    /// Redirect to home
    func redirectToHome() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
            GlobalUtility.setRootViewController(viewController: tab)
        }
    }
}
