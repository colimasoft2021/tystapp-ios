/*The Plaid API uses POST requests to communicate and HTTP response codes to indicate status and errors. All responses come in standard JSON. The Plaid API is served over HTTPS TLS v1.2+ to ensure data privacy; HTTP and HTTPS with TLS versions below 1.2 are not supported. All requests must include a Content-Type of application/json and the body must be valid JSON.
 
 Almost all Plaid API endpoints require a client_id and secret. These may be sent either in the request body or in the headers PLAID-CLIENT-ID and PLAID-SECRET.

 Every Plaid API response includes a request_id as the 'X-Request-Id' header. The request_id is included whether the API request succeeded or failed. For faster support, include the request_id when contacting support regarding a specific API call.*/

/*
 https://sandbox.plaid.com (Sandbox)
 https://development.plaid.com (Development)
 https://production.plaid.com (Production)
 */

//
//  PlaidAPIRouter.swift
//  Tyst
//
//  Created by hb on 04/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum GenerateLinkToken {
    
    struct Request {
        /// Notification Param
        var clientId: String
        var secret: String
        var clientName: String = AppConstants.appName
        var countryCode: String
        var language: String
        var user = {
            var clientUserId = UserDefaultsManager.getLoggedUserDetails()?.userInfo![0].userId
        }
        var products = ["auth"] // transactions ?
        var redirectUri: String
    }
    
    class ViewModel: WSResponseData {
        
        var expirationDate: String?
        var linkToken: String?
        var requestId: String?
        
        enum CodingKeys: String, CodingKey {
            case expiration_date
            case link_token
            case request_id
        }
        
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(expirationDate, forKey: .expiration_date)
            try container.encode(linkToken, forKey: .link_token)
            try container.encode(requestId, forKey: .request_id)
        }
        
        
        /// Init Method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            expirationDate = try values.decodeIfPresent(String.self, forKey: .expiration_date)
            linkToken = try values.decodeIfPresent(String.self, forKey: .link_token)
            requestId = try values.decodeIfPresent(String.self, forKey: .request_id)
        }
    }
}

/// Edit profile API router
enum PlaidAPIExternalRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// add Palid Api info Case
    case generateLinkToken(request: GenerateLinkToken.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .generateLinkToken:
            return "link/create/token"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .generateLinkToken(let request):
            params = [
                "client_id": request.clientId,
                "secret": request.secret,
                "client_name": request.clientName,
                "country_codes": request.countryCode,
                "language": request.language,
                "user": request.user,
                "products": request.products
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
        return ["Content-Type": "application/json"]
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


func generateLinkToken(request: GenerateLinkToken.Request, completionHandler: @escaping ([GenerateLinkToken.ViewModel?]) -> Void) {
    NetworkService.dataRequest(with: PlaidAPIExternalRouter.generateLinkToken(request: request)) { (response: WSResponse<GenerateLinkToken.ViewModel>?, error: NetworkError?) in
        if let token = response {
            if let res = token.arrayData {
                completionHandler(res)
            }
        }
    }
}

class facebookUserConsent {
    func givePermission() {
            }
}
