//
//  SignUpPresenter.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.

import UIKit

/// Protocol Sign up presentor
protocol SignUpPresentationLogic {
    /// Present email sign up Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentEmailSignUpResponse(response: Login.ViewModel?, message: String, successCode: String)
    /// Present social sign up Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentSocialSignUpResponse(response: Login.ViewModel?, message: String, successCode: String)
    /// Present state list Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentStateList(response: [StateList.ViewModel]?, message: String, successCode: String)
    
    /// Present Add Bank Account Response
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - success: API Success
    func presentAddBankAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String)
    
    /// Present FetchTransaction
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentFetchTransactionResponse(message: String, success: String)
}

/// Class for sign up presentor
class SignUpPresenter: SignUpPresentationLogic {
    
    weak var viewController: SignUpDisplayLogic?
    
    // MARK: Do something
    /// Present email sign up  Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentEmailSignUpResponse(response: Login.ViewModel?, message: String, successCode: String) {
        viewController?.didReceiveEmailSignUpResponse(viewModel: response, message: message, successCode: successCode)
    }
   
    /// Present social sign up Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentSocialSignUpResponse(response: Login.ViewModel?, message: String, successCode: String) {
        viewController?.didReceiveSocialSignUpResponse(viewModel: response, message: message, successCode: successCode)
    }
    /// Present state list Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentStateList(response: [StateList.ViewModel]?, message: String, successCode: String) {
        viewController?.didReceiveStateListResponse(response: response, message: message, successCode: successCode)
    }
    
    /// Present Add Bank Account Response
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - success: API Success
    func presentAddBankAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveAddAccountResponse(response: response, message: message, success: success)
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
