//
//  HomePresenter.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Home Presentor Protocol
protocol HomePresentationLogic {
    func presentAllData(response: Home.ViewModel?, message: String, success: String)
    func presentAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String)
    func presentFetchTransactionResponse(message: String, success: String)
    func presentGenerateAccessToken(response: GeneratePublicToken.ViewModel?, message: String, success: String)
    func presentUpdateErrorLog(message: String, success: String)
}

/// Home Presentor Class
class HomePresenter: HomePresentationLogic {
  /// Viewcontroller for home
  weak var viewController: HomeDisplayLogic?
  
  // MARK: Do something
  
    func presentAllData(response: Home.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveAllData(response: response, message: message, success: success)
    }
    
    func presentAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String) {
           self.viewController?.didReceiveAddAccountResponse(response: response, message: message, success: success)
       }
    
    func presentFetchTransactionResponse(message: String, success: String) {
        self.viewController?.didReceiveFetchTransactionResponse(message: message, success: success)
    }
    
    func presentGenerateAccessToken(response: GeneratePublicToken.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveGenerateToken(response: response, message: message, success: success)
    }
    
    func presentUpdateErrorLog(message: String, success: String) {
        self.viewController?.didReceiveUpdateErrorLog(message: message, success: success)
    }
}