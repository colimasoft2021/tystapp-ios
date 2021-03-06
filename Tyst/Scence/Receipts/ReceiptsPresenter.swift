//
//  ReceiptsPresenter.swift
//  Tyst
//
//  Created by hb on 06/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReceiptsPresentationLogic {
    func presentStateList(response: [StateList.ViewModel]?, message: String, successCode: String)
    func presentCategoryResponse(response: [CategoryList.ViewModel]?, message: String, success: String)
    func presentAddReceiptResponse(message: String, success: String)
}

class ReceiptsPresenter: ReceiptsPresentationLogic {
    weak var viewController: ReceiptsDisplayLogic?
    
    func presentStateList(response: [StateList.ViewModel]?, message: String, successCode: String) {
        viewController?.didReceiveStateListResponse(response: response, message: message, successCode: successCode)
    }
    
    func presentCategoryResponse(response: [CategoryList.ViewModel]?, message: String, success: String) {
        self.viewController?.didReceiveCategoryResponse(response: response, message: message, success: success)
    }
    
    func presentAddReceiptResponse(message: String, success: String) {
        self.viewController?.didReceiveAddReceiptResponse( message: message, success: success)
    }
}
