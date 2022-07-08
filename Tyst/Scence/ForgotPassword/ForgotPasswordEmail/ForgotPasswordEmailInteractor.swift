//
//  ForgotPasswordEmailInteractor.swift
//  WhiteLabelApp
//
//  Created by hb on 19/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol for Forgot Password Email API
protocol ForgotPasswordEmailBusinessLogic {
    /// Call Forgot password API
    ///
    /// - Parameter email: Email String
    func forgotPassword(email: String)
}

/// Protocol for Forgot Password Email Data Store
protocol ForgotPasswordEmailDataStore {
    
}

/// Class for forgot password email interactor
class ForgotPasswordEmailInteractor: ForgotPasswordEmailBusinessLogic, ForgotPasswordEmailDataStore {
    /// Presentor instance
    var presenter: ForgotPasswordEmailPresentationLogic?
    /// Worker instance
    var worker: ForgotPasswordEmailWorker?
    
    /// Call Forgot password API
    ///
    /// - Parameter email: Email String
    func forgotPassword(email: String) {
        worker = ForgotPasswordEmailWorker()
        worker?.forgotPassword(email: email, completionHandler: { (message, success) in
            self.presenter?.presentForgotPasswordResponse(message: message ?? "", success: success ?? "")
        })
    }
}