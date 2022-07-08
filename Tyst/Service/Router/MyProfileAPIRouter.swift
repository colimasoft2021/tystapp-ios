//
//  MyProfileAPIRouter.swift
//  Tyst
//
//  Created by hb on 14/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Static page router
enum MyProfileAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Static Page Case
    case userInstitutions()
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .userInstitutions:
            return "/get_user_institutions"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        switch self {
        case .userInstitutions():
            return [:]
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
