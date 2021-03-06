//
//  CategoryWorker.swift
//  Tyst
//
//  Created by hb on 28/02/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class CategoryWorker {
    func getcategoryList(request:Category.Request , completionHandler: @escaping ([Category.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: CategoryAPIRouter.categoryList(request: request)) { (responce: WSResponse<Category.ViewModel>?, error: NetworkError?) in
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
