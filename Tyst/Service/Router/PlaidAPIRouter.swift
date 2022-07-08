//
//  PlaidAPIRouter.swift
//  Tyst
//
//  Created by hb on 04/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Edit profile API router
enum PlaidAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// add Palid Api info Case
    case addBankAcoount(request: AddBankAccount.Request)
    case removeBankAcoount(request: RemoveAccount.Request)
    case fetchTransactionDetail(request: FetchTransaction.Request)
    case getAllInstitutionTransaction(request: Home.Request)
    case generatePublicToken(request: GeneratePublicToken.Request)
    case updateErrorLog(request: UpdateErrorLog.Request)
    
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .addBankAcoount:
            return "add_bank_account"
        case .removeBankAcoount:
            return "delete_bank_account"
        case .fetchTransactionDetail:
            return "fetch_transaction_details"
        case .getAllInstitutionTransaction:
            return "get_all_institutions_transaction_data"
        case .generatePublicToken:
            return "generate_public_token"
        case .updateErrorLog:
            return "insert_update_institution_error_log"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .addBankAcoount(let request):
            params = [
                "public_token": request.publicToken,
                "institution_name": request.institutionName,
                "institution_id": request.institutionId,
            ]
        case .removeBankAcoount(let request):
            params = [
                "institution_id": request.accountId,
            ]
        case .fetchTransactionDetail(let request):
            params = [
                "institution_id": request.accessToken
            ]
        case .getAllInstitutionTransaction(let request):
            params = [
                "start_date": request.startDate,
                "end_date": request.endDate
            ]
        case .generatePublicToken(let request):
            params = [
                "instituion_id": request.institutionId
            ]
        case .updateErrorLog(let request):
        params = [
            "error_code": request.errorCode,
            "institution_id": request.institutionId,
            "added_by": "",
            "status": request.status,
            "additinal_info": request.additionalInfo
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
    
    // var headers: [String: String]? { return ["Content-Type": "application/x-www-form-urlencoded", "PLAID-CLIENT": ,"PLAID-SECRET" }
    
    /*
     Every Plaid API response includes a request_id as the 'X-Request-Id' header. The request_id is included whether the API request succeeded or failed. For faster support, include the request_id when contacting support regarding a specific API call.
     */
    
    /// Files if required to attach
    var files: [MultiPartData]? {
        return nil
        
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
