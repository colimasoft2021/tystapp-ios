//
//  ExpenseListAPIRouter.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Static page router
enum ExpenseListAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Static Page Case
    case expenseList(request: ExpenseList.Request)
    
    case addTip(request: AddTip.Request)
    
    case changeTax(request: ChangeTaxAmount.Request)
    
    case deleteTrans(request: DeleteTransaction.Request)
    
    case updateCategory(request: UpdateCategory.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .expenseList:
            return "/get_transaction_data"
            
        case .addTip:
            return "/add_tip"
            
        case .changeTax:
            return "/change_tax"
            
        case .deleteTrans:
            return "/delete_transaction"
            
        case .updateCategory:
            return "/update_transaction_category"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .expenseList(let request):
            params = [
                "start_date": request.startDate,
                "end_date": request.endDate,
                "search_keyword": request.searchKeyword,
                "institution_id": request.instutionId,
                "account_id": request.accountId,
                "rec_limit": "5",
                "page_index": "\(request.pageIndex)"
            ]
            return params
            
        case .addTip(let request):
            params = [
                "transaction_id": request.transId,
                "tip_amount":request.tipAmount
            ]
            return params
            
        case .changeTax(let request):
            params = [
                "transaction_id": request.transId,
                "tax_amount":request.taxAmount,
                "reason_id": request.reasonId
            ]
            return params
            
        case .deleteTrans(let request):
            params = [
                "transaction_id": request.transId
            ]
            return params
            
        case .updateCategory(let request):
            params = [
                "transaction_id": request.transId,
                "category_id":request.categoryId,
                "category_name" : request.categoryName
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

