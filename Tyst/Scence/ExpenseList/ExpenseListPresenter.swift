//
//  ExpenseListPresenter.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol ExpenseListPresentationLogic {
    func presentAllData(response: ExpenseList.ViewModel?, message: String, success: String,currPage: String, nextPage: Bool)
}

class ExpenseListPresenter: ExpenseListPresentationLogic {
    weak var viewController: ExpenseListDisplayLogic?
    
    // MARK: Do something
    
    func presentAllData(response: ExpenseList.ViewModel?, message: String, success: String,currPage: String, nextPage: Bool) {
        self.viewController?.didReceiveAllData(response: response, message: message, success: success, currPage: currPage, nextPage: nextPage)
    }
    
    
}
