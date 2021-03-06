//
//  HomeModels.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

///Home Request and Reponse
enum Home {
    struct Request {
        var startDate: String
        var endDate: String
    }
    
    /// Reponse Class
    class ViewModel: WSResponseData {
        var getInstitutionTotalAmount: [InstitutionDetail]?
        var totalAmount: [TotalAmount]?
        
        enum CodingKeys: String, CodingKey {
            case get_institutions_total_amount
            case total_amount
        }
        
        /// Init default method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            getInstitutionTotalAmount = try values.decodeIfPresent([InstitutionDetail].self, forKey: .get_institutions_total_amount)
            totalAmount = try values.decodeIfPresent([TotalAmount].self, forKey: .total_amount)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(getInstitutionTotalAmount, forKey: .get_institutions_total_amount)
            try container.encode(totalAmount, forKey: .total_amount)
        }
        
        class InstitutionDetail: Codable {
            var transactionAmount: String?
            var taxAmount: String?
            var institutionName: String?
            var accessToken: String?
            var institutionID: String?
            var uniqueInstitutionId: String?
            var errorCode: String?
            var errorMessage: String?
            var loginRequired: String?
            
            
            private enum CodingKeys: String, CodingKey {
                case transaction_amount
                case tax_amount
                case institution_name
                case access_token
                case institution_id
                case unique_institution_id
                case error_code
                case error_message
                case login_required
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(transactionAmount, forKey: .transaction_amount)
                try container.encode(taxAmount, forKey: .tax_amount)
                try container.encode(institutionName, forKey: .institution_name)
                try container.encode(accessToken, forKey: .access_token)
                try container.encode(institutionID, forKey: .institution_id)
                 try container.encode(uniqueInstitutionId, forKey: .unique_institution_id)
                 try container.encode(errorCode, forKey: .error_code)
                 try container.encode(errorMessage, forKey: .error_message)
                 try container.encode(loginRequired, forKey: .login_required)
                
            }
            
            required public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                transactionAmount = try values.decodeIfPresent(String.self, forKey: .transaction_amount)
                taxAmount = try values.decodeIfPresent(String.self, forKey: .tax_amount)
                institutionName = try values.decodeIfPresent(String.self, forKey: .institution_name)
                accessToken = try values.decodeIfPresent(String.self, forKey: .access_token)
                institutionID = try values.decodeIfPresent(String.self, forKey: .institution_id)
                uniqueInstitutionId = try values.decodeIfPresent(String.self, forKey: .unique_institution_id)
                errorCode = try values.decodeIfPresent(String.self, forKey: .error_code)
                errorMessage = try values.decodeIfPresent(String.self, forKey: .error_message)
                loginRequired = try values.decodeIfPresent(String.self, forKey: .login_required)
            }
        }
        
        class TotalAmount: Codable {
            var totalTransactionAmount: String?
            var totalTaxAmount : String?
            
            private enum CodingKeys: String, CodingKey {
                case total_transaction_amount
                case total_tax_amount
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(totalTransactionAmount, forKey: .total_transaction_amount )
                try container.encode(totalTaxAmount, forKey: .total_tax_amount)
            }
            
            required public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                totalTransactionAmount = try values.decodeIfPresent(String.self, forKey: .total_transaction_amount)
                totalTaxAmount = try values.decodeIfPresent(String.self, forKey: .total_tax_amount)
            }
        }
    }
}


enum GeneratePublicToken {
    
    struct Request {
        /// Notification Param
        var institutionId: String
    }
    
    
   /// Reponse Class
    class ViewModel: WSResponseData {
        
        var userInstitutionId: String?
        var publicToken: String?
        
        enum CodingKeys: String, CodingKey {
            case user_institution_id
            case public_token
        }
        
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(userInstitutionId, forKey: .user_institution_id)
            try container.encode(publicToken, forKey: .public_token)
        }
        
        
        /// Init Method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            userInstitutionId = try values.decodeIfPresent(String.self, forKey: .user_institution_id)
            publicToken = try values.decodeIfPresent(String.self, forKey: .public_token)
        }
    }
}

enum UpdateErrorLog {
    
    struct Request {
        /// Notification Param
        var institutionId: String
        var status: String
        var errorCode: String
        var additionalInfo: String
        
    }
    
    
   /// Reponse Class
    class ViewModel: WSResponseData {
        
//        var userInstitutionId: String?
//        var publicToken: String?
//
//        enum CodingKeys: String, CodingKey {
//            case user_institution_id
//            case public_token
//        }
        
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(userInstitutionId, forKey: .user_institution_id)
//            try container.encode(publicToken, forKey: .public_token)
        }
        
        
        /// Init Method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            userInstitutionId = try values.decodeIfPresent(String.self, forKey: .user_institution_id)
//            publicToken = try values.decodeIfPresent(String.self, forKey: .public_token)
        }
    }
}
