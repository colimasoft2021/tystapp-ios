//
//  ChangeTaxWorker.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

class ChangeTaxWorker {
    
    func getChangeTaxList(completionHandler: @escaping ([ChangeTax.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: BankTransactionAPIRouter.changeTaxList()) { (responce: WSResponse<ChangeTax.ViewModel>?, error: NetworkError?) in
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
}
