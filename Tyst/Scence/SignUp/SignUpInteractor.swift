//
//  SignUpInteractor.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.

import UIKit

/// Protocol for Sign up Email API
protocol SignUpBusinessLogic {
    /// Call Sign up Email API
    ///
    /// - Parameter request: Sign Up Email Request
    func callSignUpEmailAPI(request: SignUp.SignUpEmailModel.Request)
   
    /// Call Social Sign Up API
    ///
    /// - Parameter request: Social Sign up Request
    func callSocialSignUpAPI(request: SignUp.SignUpSocialModel.Request)
    /// Call State API
    func callStateAPI()
    
    /// Call Add Bank Account Api
    ///
    /// - Parameter request: Login email Social Request
    func addBankAccount(request: AddBankAccount.Request)
    
    /// Call fetch transaction API
    ///
    /// - Parameter request: Login email Social Request
    func fetchTrnasaction(request: FetchTransaction.Request) 
}

/// Protocol for Sign up Email Data Store
protocol SignUpDataStore {
    //var name: String { get set }
}

/// Class for Sign up Interactor
class SignUpInteractor: SignUpBusinessLogic, SignUpDataStore {
    
    /// Presentor instance
    var presenter: SignUpPresentationLogic?
    /// Worker instance
    var worker: SignUpWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    /// Call Sign up Email API
    ///
    /// - Parameter request: Sign Up Email Request
    func callSignUpEmailAPI(request: SignUp.SignUpEmailModel.Request) {
        worker = SignUpWorker()
        worker?.getEmailSignUpResponse(request: request, completionHandler: { (response, message, successCode) in
            self.presenter?.presentEmailSignUpResponse(response: response, message: message ?? "", successCode: successCode ?? "0")
        })
    }
    
    /// Call Add Bank Account Api
    ///
    /// - Parameter request: Login email Social Request
    func addBankAccount(request: AddBankAccount.Request) {
        worker = SignUpWorker()
        worker?.addBankAccount(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentAddBankAccountResponse(response: response                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               , message: message ?? "", success: success ?? "")
        })
    }
    
    /// Call Social Sign Up API
    ///
    /// - Parameter request: Social Sign up Request
    func callSocialSignUpAPI(request: SignUp.SignUpSocialModel.Request) {
        worker = SignUpWorker()
        worker?.getSocialSignUpResponse(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentSocialSignUpResponse(response: response, message: message ?? "", successCode: success ?? "0")
        })
    }
    
    /// Call State API
    func callStateAPI() {
        worker = SignUpWorker()
        worker?.getStateListResponse(completionHandler: { (response, message, success) in
            self.presenter?.presentStateList(response: response, message: message ?? "", successCode: success ?? "0")
        })
    }
    
    
    /// Call fetch transaction API
    ///
    /// - Parameter request: Login email Social Request
    func fetchTrnasaction(request: FetchTransaction.Request) {
        worker = SignUpWorker()
        worker?.fetchTransactionDetail(request: request, completionHandler: { (message, success) in
            self.presenter?.presentFetchTransactionResponse(message: message ?? "", success: success ?? "")
        })
    }
   
}
