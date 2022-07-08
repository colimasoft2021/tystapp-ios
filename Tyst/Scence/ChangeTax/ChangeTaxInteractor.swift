//
//  ChangeTaxInteractor.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol ChangeTaxBusinessLogic {
    func callChangeTaxListAPI()
}

protocol ChangeTaxDataStore {
    //var name: String { get set }
}

class ChangeTaxInteractor: ChangeTaxBusinessLogic, ChangeTaxDataStore {
    var presenter: ChangeTaxPresentationLogic?
    var worker: ChangeTaxWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func callChangeTaxListAPI() {
        worker = ChangeTaxWorker()
        worker?.getChangeTaxList(completionHandler: { (response, message, success) in
            self.presenter?.presentChangeTaxList(response: response, message: message ?? "", Success: success ?? "")
        })
    }
}
