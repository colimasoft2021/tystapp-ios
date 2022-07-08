//
//  ExportAPIRouter.swift
//  Tyst
//
//  Created by hb on 08/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Edit profile API router
enum ExportAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// add Palid Api info Case
    case getLog()
    case createLogs(request: CreateLogs.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .getLog:
            return "get_log_list"
            
        case .createLogs:
            return "generate_log"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .getLog:
            break
        case .createLogs(let request):
            params = [
                "start_date": request.startDate,
                "end_date": request.endDate
            ]
        }
        return params
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
        switch self {
        case .getLog:
            return nil
            
        case .createLogs:
            return nil
        }
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
