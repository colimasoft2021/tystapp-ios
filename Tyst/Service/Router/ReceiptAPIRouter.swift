//
//  ReceiptAPIRouter.swift
//  Tyst
//
//  Created by hb on 07/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Edit profile API router
enum ReceiptAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// add Palid Api info Case
    case getCategory()
    case addCashData(request: Receipts.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .getCategory:
            return "category_list"
        case .addCashData:
            return "pay_by_cash"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .getCategory:
            break
        case .addCashData(let request):
            params = [
                "category": request.category,
                "store_name": request.name,
                "location": request.location,
                "state_id": request.stateId,
                "zip_code": request.zipCode,
                "amount": request.amount,
                "transaction_date": request.date,
                "tax_amount": request.tax,
                "latitude": request.lat,
                "longitude": request.long,
                "images_count": request.imageCount
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
        case .addCashData(let request):
            var arrMultiPart = [MultiPartData]()
            var imageData = [Data]()
            for pickedImage in request.imageArray {
                let data = pickedImage.jpegData(compressionQuality: 0.5)
                imageData.append(data!)
            }
            if request.imageArray.count > 0 {
                for count in 0...request.imageArray.count - 1 {
                    arrMultiPart.append(MultiPartData(fileName: "receipt_image_\(count + 1).jpg", data: imageData[count] as Data, paramKey: "receipt_image_\(count + 1)", mimeType: "image/jpg", fileKey: "receipt_image_\(count + 1)"))
                }
            }
            return arrMultiPart
            
        case .getCategory:
            return nil
        }
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
