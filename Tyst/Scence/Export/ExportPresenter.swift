//
//  ExportPresenter.swift
//  Tyst
//
//  Created by hb on 06/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ExportPresentationLogic {
    func presentLogs(response: [Export.ViewModel]?, message: String, success: String)
    func presentCreateLogResponse(message: String, Success: String)
}

class ExportPresenter: ExportPresentationLogic {
    weak var viewController: ExportDisplayLogic?
    
    func presentLogs(response: [Export.ViewModel]?, message: String, success: String) {
        self.viewController?.didReceiveLogs(response: response, message: message, success: success)
    }
    
    func presentCreateLogResponse(message: String, Success: String) {
        self.viewController?.didReceiveCreateLog(message: message, success: Success)
    }
}
