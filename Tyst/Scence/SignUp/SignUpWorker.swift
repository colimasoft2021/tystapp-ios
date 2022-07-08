//
//  SignUpWorker.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.

import UIKit

/// Class for sign up API call
class SignUpWorker {
    /// API call for email sign up
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getEmailSignUpResponse(request: SignUp.SignUpEmailModel.Request, completionHandler: @escaping (Login.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.signUpWithEmail(request: request)) { (responce: WSResponse<Login.ViewModel>?, error: NetworkError?) in
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
    func addBankAccount(request: AddBankAccount.Request, completionHandler: @escaping (AddBankAccount.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
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
    
    
    /// API call for social sign up
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getSocialSignUpResponse(request: SignUp.SignUpSocialModel.Request, completionHandler: @escaping (Login.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.socialSignUp(request: request)) { (responce: WSResponse<Login.ViewModel>?, error: NetworkError?) in
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
    /// API call for get state list
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getStateListResponse(completionHandler: @escaping ([StateList.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.stateList) { (responce: WSResponse<StateList.ViewModel>?, error: NetworkError?) in
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
