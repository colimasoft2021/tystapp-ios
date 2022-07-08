//
//  MyProfilePresenter.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// My Profile Presenter
protocol MyProfilePresentationLogic {
    func presentAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String)
    func presentRemoveAccountResponse(message: String, success: String)
    func presentUserInstituionsResponse(response: [AddBankAccount.ViewModel]?, message: String, success: String)
    /// Present FetchTransaction
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentFetchTransactionResponse(message: String, success: String)
}

/// Presenter for my profile
class MyProfilePresenter: MyProfilePresentationLogic {
    /// Controller for my profile
    weak var viewController: MyProfileDisplayLogic?
    
    func presentAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveAddAccountResponse(response: response, message: message, success: success)
    }
    
    func presentRemoveAccountResponse(message: String, success: String) {
        self.viewController?.didReceiveRemoveAccountResponse(message: message, success: success)
    }
    
    func presentUserInstituionsResponse(response: [AddBankAccount.ViewModel]?, message: String, success: String) {
        self.viewController?.didReceiveUserInstitutionsResponse(response: response, message: message, success: success)
    }
    /// Present FetchTransaction
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentFetchTransactionResponse(message: String, success: String) {
        self.viewController?.didReceiveFetchTransactionResponse(message: message, success: success)
    }
}
