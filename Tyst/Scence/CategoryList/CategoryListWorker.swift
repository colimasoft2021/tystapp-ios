//
//  CategoryListWorker.swift
//  Tyst
//
//  Created by hb on 30/03/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class CategoryListWorker {
  func getCategoryResponse(completionHandler: @escaping ([CategoryList.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
      NetworkService.dataRequest(with: ReceiptAPIRouter.getCategory()) { (responce: WSResponse<CategoryList.ViewModel>?, error: NetworkError?) in
          if let detail = responce {
              if let resparray = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                  completionHandler(resparray, msg, detail.setting?.success)
              } else {
                  completionHandler(nil, detail.setting?.message, detail.setting?.success)
              }
          } else {
              completionHandler(nil, AlertMessage.defaultError, "0")
          }
      }
  }
}