//
//  LoginEmailAndSocialWorker.swift
//  WhiteLabelApp
//
//  Created by hb on 16/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
/// Class for login email and social
class LoginEmailAndSocialWorker {
    /// API call for login
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func login(request: LoginEmailAndSocialModel.Request, completionHandler: @escaping (Login.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.loginWithEmail(email: request.email, password: request.password)) { (responce: WSResponse<Login.ViewModel>?, error: NetworkError?) in
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
    
    /// API call for login
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
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
    
    /// API call for transaction Detail
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func fetchTransactionDetail(request: FetchTransaction.Request, completionHandler: @escaping (_ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: PlaidAPIRouter.fetchTransactionDetail(request: request)) { (responce: WSResponse<Setting.ViewModel>?, error: NetworkError?) in
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
    
    /// API call for social login
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func socialLogin(request: LoginEmailAndSocialModel.SocialRequest, completionHandler: @escaping (Login.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.socialLogin(socialLoginType: request.type, socialLoginId: request.id)) { (responce: WSResponse<Login.ViewModel>?, error: NetworkError?) in
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
    
    
    func resendEmail(request: ResendLink.Request, completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.ResendLink(request: request)) { (responce: WSResponse<Setting.ViewModel>?, error: NetworkError?) in
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
