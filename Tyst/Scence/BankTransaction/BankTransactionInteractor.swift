//
//  BankTransactionInteractor.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol BankTransactionBusinessLogic {
    func getBankTransaction(request: BankTransaction.Request)
    func callAddTip(request: AddTip.Request)
    func callChangeTax(request: ChangeTaxAmount.Request)
    func callUpdateCategory(request: UpdateCategory.Request)
}

protocol BankTransactionDataStore {
    //var name: String { get set }
}

class BankTransactionInteractor: BankTransactionBusinessLogic, BankTransactionDataStore {
    var presenter: BankTransactionPresentationLogic?
    var worker: BankTransactionWorker?
    
    
    func getBankTransaction(request: BankTransaction.Request) {
        worker = BankTransactionWorker()
        worker?.getTransactionDetail(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentBankTransaction(response: response, message: message ?? "", success: success ?? "")
        })
    }
    func callAddTip(request: AddTip.Request) {
        worker = BankTransactionWorker()
        worker?.addTip(request: request, completionHandler: { (message, success) in
            self.presenter?.presentAddTipResponse(message: message ?? "", Success: success ?? "")
        })
    }
    
    func callChangeTax(request: ChangeTaxAmount.Request) {
        worker = BankTransactionWorker()
        worker?.changeTax(request: request, completionHandler: { (message, success) in
            self.presenter?.presentChangeTaxResponse(message: message ?? "", Success: success ?? "")
        })
    }
    
    func callUpdateCategory(request: UpdateCategory.Request) {
        worker = BankTransactionWorker()
        worker?.changeCategory(request: request, completionHandler: { (message, success) in
            self.presenter?.presentUpdateCategoryResponse(message: message ?? "", Success: success ?? "")
        })
    }
}
