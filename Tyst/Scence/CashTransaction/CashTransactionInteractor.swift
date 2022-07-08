//
//  CashTransactionInteractor.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol CashTransactionBusinessLogic {
    func getBankTransaction(request: BankTransaction.Request)
    func callAddTip(request: AddTip.Request)
    func callChangeTax(request: ChangeTaxAmount.Request)
    func callDeleteTransaction(request: DeleteTransaction.Request)
    func callUpdateCategory(request: UpdateCategory.Request)
}

protocol CashTransactionDataStore {
    //var name: String { get set }
}

class CashTransactionInteractor: CashTransactionBusinessLogic, CashTransactionDataStore {
    var presenter: CashTransactionPresentationLogic?
    var worker: CashTransactionWorker?
    //var name: String = ""
    
    
    
    func getBankTransaction(request: BankTransaction.Request) {
        worker = CashTransactionWorker()
        worker?.getTransactionDetail(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentBankTransaction(response: response, message: message ?? "", success: success ?? "")
        })
    }
    func callAddTip(request: AddTip.Request) {
        worker = CashTransactionWorker()
        worker?.addTip(request: request, completionHandler: { (message, success) in
            self.presenter?.presentAddTipResponse(message: message ?? "", Success: success ?? "")
        })
    }
    
    func callChangeTax(request: ChangeTaxAmount.Request) {
        worker = CashTransactionWorker()
        worker?.changeTax(request: request, completionHandler: { (message, success) in
            self.presenter?.presentChangeTaxResponse(message: message ?? "", Success: success ?? "")
        })
    }
    
    
    func callDeleteTransaction(request: DeleteTransaction.Request) {
        worker = CashTransactionWorker()
        worker?.deleteTransaction(request: request, completionHandler: { (message, success) in
            self.presenter?.presentDeleteTransactionResponse(message: message ?? "", Success: success ?? "")
        })
    }
    
    func callUpdateCategory(request: UpdateCategory.Request) {
        worker = CashTransactionWorker()
        worker?.changeCategory(request: request, completionHandler: { (message, success) in
            self.presenter?.presentUpdateCategoryResponse(message: message ?? "", Success: success ?? "")
        })
    }
}
