//
//  ForgotPasswordRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 19/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum ForgotPasswordRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Forgot password with email Case
    case forgotPasswordEmail(email: String)

    
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .forgotPasswordEmail:
            return "forgot_password"
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .forgotPasswordEmail(let email):
            params = [
                "email": email
            ]
            
        }
        return params
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    var files: [MultiPartData]? {
        return nil
    }
    
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
