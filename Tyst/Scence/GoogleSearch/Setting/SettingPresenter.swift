//
//  SettingPresenter.swift
//  WhiteLabelApp
//
//  Created by hb on 23/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Settings Presentor Protocol
protocol SettingPresentationLogic {
    /// Present logout response
    ///
    /// - Parameters:
    ///   - message: API Response
    ///   - Success: API Success
    func presentLogout(message: String, Success: String)
    /// Present Delete Account response
    ///
    /// - Parameters:
    ///   - message: API Response
    ///   - Success: API Success
    func presentDeleteAccount(message: String, Success: String)
    /// Present Update Push notifications response
    ///
    /// - Parameters:
    ///   - message: API Response
    ///   - Success: API Success
    func presentUpdatePushNotification(message: String, Success: String)
    /// Present Go Ad Free response
    ///
    /// - Parameters:
    ///   - message: API Response
    ///   - Success: API Success
    func presentGoAddFree(message: String, success: String)
}

class SettingPresenter: SettingPresentationLogic {
    /// Viewcontroller for settings
    weak var viewController: SettingDisplayLogic?
    /// Present logout response
    ///
    /// - Parameters:
    ///   - message: API Response
    ///   - Success: API Success
    func presentLogout(message: String, Success: String) {
        self.viewController?.logout(message: message, Success: Success)
    }
    /// Present Delete Account response
    ///
    /// - Parameters:
    ///   - message: API Response
    ///   - Success: API Success
    func presentDeleteAccount(message: String, Success: String) {
        self.viewController?.deleteAccount(message: message, Success: Success)
    }
    
    /// Present Update Push notifications response
    ///
    /// - Parameters:
    ///   - message: API Response
    ///   - Success: API Success
    func presentUpdatePushNotification(message: String, Success: String) {
        self.viewController?.updatePushNotification(message: message, Success: Success)
    }
    /// Present Go Ad Free response
    ///
    /// - Parameters:
    ///   - message: API Response
    ///   - Success: API Success
    func presentGoAddFree(message: String, success: String) {
        self.viewController?.didReceiveGoAddFree(message: message, success: success)
    }
}