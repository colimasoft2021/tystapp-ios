//
//  NetworkError.swift
//  Note
//
//  Created by HB1 on 28/09/18.
//  Copyright © 2018 HB. All rights reserved.
//

import Foundation
/// Enum for response error
public enum NetworkError: Error {
    
    // MARK: - Client Error: 400...499
    case clientError(statusCode: Int)
    
    // MARK: - Server Error: 500...599
    case serverError(statusCode: Int)
    
    // MARK: - Parsing Error
    case parsingError(error: Error)
    
    case requestError(errorMessage: String)
    
    // MARK: - Other
    case other(statusCode: Int?, error: Error?)
    
    // MARK: - Network Error With Status Code
    case requestErrorMessageWithStatusCode(errorMessage: String)
    
}
