//
//  BankTransactionWorker.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

class BankTransactionWorker {
    func getTransactionDetail(request:BankTransaction.Request , completionHandler: @escaping ([BankTransaction.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: BankTransactionAPIRouter.bankTransaction(request: request)) { (responce: WSResponse<BankTransaction.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let response = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(response, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, AlertMessage.defaultError, "0")
            }
        }
    }
    
    func addTip(request: AddTip.Request, completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: ExpenseListAPIRouter.addTip(request: request)) { (responce: WSResponse<AddTip.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if  detail.arrayData != nil, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(msg, detail.setting?.success)
                } else {
                    completionHandler(detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(AlertMessage.defaultError, "0")
            }
        }
    }
    
    func changeTax(request: ChangeTaxAmount.Request, completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: ExpenseListAPIRouter.changeTax(request: request)) { (responce: WSResponse<ChangeTaxAmount.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if  detail.arrayData != nil, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(msg, detail.setting?.success)
                } else {
                    completionHandler(detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(AlertMessage.defaultError, "0")
            }
        }
    }
    
    func changeCategory(request: UpdateCategory.Request, completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: ExpenseListAPIRouter.updateCategory(request: request)) { (responce: WSResponse<UpdateCategory.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if  detail.arrayData != nil, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(msg, detail.setting?.success)
                } else {
                    completionHandler(detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(AlertMessage.defaultError, "0")
            }
        }
    }
    
}
