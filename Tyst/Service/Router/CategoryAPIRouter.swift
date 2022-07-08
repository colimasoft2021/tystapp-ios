//
//  BankTransactionAPIRouter.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Static page router
enum CategoryAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Static Page Case
    case categoryList(request: Category.Request)
    
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .categoryList:
            return "/get_user_accounts"
        }
        
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .categoryList(let request):
            params = [
                "institution_id": request.instId
            ]
            return params
            
        }
    }
    
    /// Parameter Encoding required
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    /// Headers for the url request
    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded", "AUTHTOKEN": UserDefaultsManager.authToken]
    }
    
    /// Files if required to attach
    var files: [MultiPartData]? {
        return nil
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}


