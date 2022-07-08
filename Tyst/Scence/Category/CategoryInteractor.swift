//
//  CategoryInteractor.swift
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

protocol CategoryBusinessLogic {
    func callCategoryAPI(request: Category.Request)
}

protocol CategoryDataStore {
    //var name: String { get set }
}

class CategoryInteractor: CategoryBusinessLogic, CategoryDataStore {
    var presenter: CategoryPresentationLogic?
    var worker: CategoryWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func callCategoryAPI(request: Category.Request) {
        worker = CategoryWorker()
        worker?.getcategoryList(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentCategory(response: response, message: message ?? "", success: success ?? "0")
        })
    }
}
