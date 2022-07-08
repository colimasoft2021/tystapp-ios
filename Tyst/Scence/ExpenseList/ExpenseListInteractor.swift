//
//  ExpenseListInteractor.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol ExpenseListBusinessLogic {
    func getAllData(request: ExpenseList.Request, showLoader: Bool)
    
}

protocol ExpenseListDataStore {
    //var name: String { get set }
}

class ExpenseListInteractor: ExpenseListBusinessLogic, ExpenseListDataStore {
    var presenter: ExpenseListPresentationLogic?
    var worker: ExpenseListWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func getAllData(request: ExpenseList.Request, showLoader: Bool) {
        worker = ExpenseListWorker()
        worker?.getExpenseListDetail(request: request,loader: showLoader, completionHandler: { (response, message, success, currPage, nextPage ) in
            self.presenter?.presentAllData(response: response, message: message ?? "", success: success ?? "", currPage: currPage, nextPage: nextPage)
        })
    }
    
    
}
