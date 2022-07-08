//
//  ExpenseListWorker.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

class ExpenseListWorker {
    /// API call for transactions
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getExpenseListDetail(request: ExpenseList.Request,loader: Bool, completionHandler: @escaping (ExpenseList.ViewModel?, _ message: String?, _ successCode: String?,_ currentPage: String, _ isNextPage: Bool) -> Void) {
        NetworkService.dataRequest(with: ExpenseListAPIRouter.expenseList(request: request),showHud: loader ) { (responce: WSResponse<ExpenseList.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.dictData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( resparray, msg, detail.setting?.success, detail.setting?.currentPage ?? "", detail.setting?.isNextPage ?? false)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success, detail.setting?.currentPage ?? "", detail.setting?.isNextPage ?? false)
                }
            } else {
                completionHandler(nil, AlertMessage.defaultError, "0", "0", false)
            }
        }
    }
    
    
}
