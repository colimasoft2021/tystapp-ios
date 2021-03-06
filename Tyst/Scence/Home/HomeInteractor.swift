//
//  HomeInteractor.swift
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

/// Protocol for Home API Call
protocol HomeBusinessLogic {
    func getAllData(request: Home.Request, showLoader: Bool)
    func addAccount(request: AddBankAccount.Request)
    func fetchTrnasaction(request: FetchTransaction.Request)
    func generatePublicToken(request: GeneratePublicToken.Request)
    func updateErrorLog(request: UpdateErrorLog.Request)
}

/// Protocol home Data datastore
protocol HomeDataStore {
    //var name: String { get set }
}

/// Class for home API interactor
class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    /// Presentor instance
    var presenter: HomePresentationLogic?
    /// Worker instance
    var worker: HomeWorker?
    
    func getAllData(request: Home.Request, showLoader: Bool) {
        worker = HomeWorker()
        worker?.getTransactionDetail(request: request,loader: showLoader, completionHandler: { (response, message, success ) in
            self.presenter?.presentAllData(response: response, message: message ?? "", success: success ?? "")
        })
    }
    
    func addAccount(request: AddBankAccount.Request) {
        worker = HomeWorker()
        worker?.addBankAccount(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentAddAccountResponse(response: response, message: message ?? "", success: success ?? "")
        })
    }
    
    func fetchTrnasaction(request: FetchTransaction.Request) {
        worker = HomeWorker()
        worker?.fetchTransactionDetail(request: request, completionHandler: { (message, success) in
            self.presenter?.presentFetchTransactionResponse(message: message ?? "", success: success ?? "")
        })
    }
    
    func generatePublicToken(request: GeneratePublicToken.Request) {
        worker = HomeWorker()
        worker?.generatePublicToken(request: request, completionHandler: { (response, message, success ) in
            self.presenter?.presentGenerateAccessToken(response: response, message: message ?? "", success: success ?? "0")
        })
    }
    
    func updateErrorLog(request: UpdateErrorLog.Request) {
        worker = HomeWorker()
        worker?.updateErrorLog(request: request, completionHandler: { ( message, success ) in
            self.presenter?.presentUpdateErrorLog( message: message ?? "", success: success ?? "0")
        })
    }
}
