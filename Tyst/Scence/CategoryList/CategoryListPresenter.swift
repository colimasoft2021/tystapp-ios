//
//  CategoryListPresenter.swift
//  Tyst
//
//  Created by hb on 30/03/20.


import UIKit

protocol CategoryListPresentationLogic {
    func presentCategoryList(response: [CategoryList.ViewModel]?, message: String, success: String)
}

class CategoryListPresenter: CategoryListPresentationLogic {
    weak var viewController: CategoryListDisplayLogic?
    
    
    func presentCategoryList(response: [CategoryList.ViewModel]?, message: String, success: String) {
        viewController?.didReceivePresentCategoryList(response: response, message: message, success: success)
    }
    
}
