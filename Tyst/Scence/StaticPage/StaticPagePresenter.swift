//
//  StaticPagePresenter.swift
//  Pups
//
//  Created by hb on 07/05/19.

import Foundation

import UIKit

/// Protocol for static page
protocol StaticPagePresentationLogic {
    /// Present Static Page Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentStaticPageResponse(response: [StaticPage.ViewModel]?, message: String, successCode: String)
    func presentStaticPageUpdateResponse(response: [StaticPage.ViewModel]?, message: String, successCode: String)
}

/// Class for static page
class StaticPagePresenter: StaticPagePresentationLogic {
    /// View Controller for static page
    weak var viewController: StaticPageDisplayLogic?
    /// Present Static Page Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentStaticPageResponse(response: [StaticPage.ViewModel]?, message: String, successCode: String) {
        viewController?.didReceiveStaticPageResponse(viewModel: response, message: message, successCode: successCode)
    }
    
    func presentStaticPageUpdateResponse(response: [StaticPage.ViewModel]?, message: String, successCode: String) {
        viewController?.didReceiveStaticPageVersionUpdateResponse(viewModel: response, message: message, successCode: successCode)
    }
}
