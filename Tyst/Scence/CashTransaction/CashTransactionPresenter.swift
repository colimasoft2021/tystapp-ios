//
//  CashTransactionPresenter.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol CashTransactionPresentationLogic {
    func presentBankTransaction(response: [BankTransaction.ViewModel]?, message: String, success: String)
    func presentAddTipResponse(message: String, Success: String)
    func presentChangeTaxResponse(message: String, Success: String)
    func presentDeleteTransactionResponse(message: String, Success: String)
    func presentUpdateCategoryResponse(message: String, Success: String)
}

class CashTransactionPresenter: CashTransactionPresentationLogic {
    weak var viewController: CashTransactionDisplayLogic?

    func presentBankTransaction(response: [BankTransaction.ViewModel]?, message: String, success: String) {
        self.viewController?.didReceiveBankTransaction(response: response, message: message, success: success)
    }
    
    func presentAddTipResponse(message: String, Success: String) {
        self.viewController?.didReceiveAddTipResponse(message: message, success: Success)
    }
    
    func presentChangeTaxResponse(message: String, Success: String) {
        self.viewController?.didReceiveChangeTaxResponse(message: message, success: Success)
    }
    
    func presentDeleteTransactionResponse(message: String, Success: String) {
        self.viewController?.didReceiveDeleteTransactionResponse(message: message, success: Success)
    }
    func presentUpdateCategoryResponse(message: String, Success: String) {
        self.viewController?.didReceiveUpdateCategoryResponse(message: message, success: Success)
    }
}
