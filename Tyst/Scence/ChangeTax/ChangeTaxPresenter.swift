//
//  ChangeTaxPresenter.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol ChangeTaxPresentationLogic {
    func presentChangeTaxList(response: [ChangeTax.ViewModel]?, message: String, Success: String)
}

class ChangeTaxPresenter: ChangeTaxPresentationLogic {
    weak var viewController: ChangeTaxDisplayLogic?
    
    // MARK: Do something
    
    func presentChangeTaxList(response: [ChangeTax.ViewModel]?, message: String, Success: String) {
        viewController?.didReceiveChangeTaxList(response: response, message: message, Success: Success)
    }
}
