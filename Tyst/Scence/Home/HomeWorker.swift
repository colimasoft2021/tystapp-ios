//
//  HomeWorker.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Class for Home API Calls
class HomeWorker {
    
    /// API call for transactions
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getTransactionDetail(request: Home.Request,loader: Bool, completionHandler: @escaping (Home.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: PlaidAPIRouter.getAllInstitutionTransaction(request: request),showHud: loader ) { (responce: WSResponse<Home.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.dictData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( resparray, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, AlertMessage.defaultError, "0")
            }
        }
    }
    
    
    func addBankAccount(request: AddBankAccount.Request, completionHandler: @escaping (AddBankAccount.ViewModel?,_ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: PlaidAPIRouter.addBankAcoount(request: request)) { (responce: WSResponse<AddBankAccount.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let response = detail.arrayData, response.count > 0, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(response.first , msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, AlertMessage.defaultError, "0")
            }
        }
        
    }
    
    func fetchTransactionDetail(request: FetchTransaction.Request, completionHandler: @escaping (_ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: PlaidAPIRouter.fetchTransactionDetail(request: request),showHud: false) { (responce: WSResponse<Setting.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let _ = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(msg, detail.setting?.success)
                } else {
                    completionHandler(detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(AlertMessage.defaultError, "0")
            }
        }
    }
    
    func generatePublicToken(request: GeneratePublicToken.Request, completionHandler: @escaping (GeneratePublicToken.ViewModel?,_ message: String?, _ successCode: String?) -> Void) {
           NetworkService.dataRequest(with: PlaidAPIRouter.generatePublicToken(request: request)) { (responce: WSResponse<GeneratePublicToken.ViewModel>?, error: NetworkError?) in
               if let detail = responce {
                   if let response = detail.arrayData, response.count > 0, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                       completionHandler(response.first , msg, detail.setting?.success)
                   } else {
                       completionHandler(nil, detail.setting?.message, detail.setting?.success)
                   }
               } else {
                   completionHandler(nil, AlertMessage.defaultError, "0")
               }
           }
           
       }
    
    func updateErrorLog(request: UpdateErrorLog.Request, completionHandler: @escaping (_ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: PlaidAPIRouter.updateErrorLog(request: request)) { (responce: WSResponse<UpdateErrorLog.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let _ = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
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
