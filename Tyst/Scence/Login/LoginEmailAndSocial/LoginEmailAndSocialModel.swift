//
//  LoginEmailAndSocialModel.swift
//  WhiteLabelApp
//
//  Created by hb on 17/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation

enum LoginEmailAndSocialModel {
    /// Struct for API Request
    struct Request {
        var email: String
        var password: String
    }
    
    struct SocialRequest {
        var type: String
        var id: String
    }
}

enum FetchTransaction {
    struct Request {
        var accessToken: String
    }
}

enum AddBankAccount {
    struct Request {
        var publicToken: String
        var institutionName: String
        var institutionId: String
    }
    
    /// Reponse Class
    class ViewModel: WSResponseData {
        var institutionId: String?
        var institutionName: String?
        var accessToken: String?
        var publicToken: String?
        var isFirstTransactionsDumped: String?
        var addedAt: String?
        var status: String?
        var logo: String?
        
        enum CodingKeys: String, CodingKey {
            case institution_id
            case institution_name
            case access_token
            case public_token
            case is_first_transactions_dumped
            case added_at
            case status
            case institution_logo
        }
        
        /// Init default method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            institutionId = try values.decodeIfPresent(String.self, forKey: .institution_id)
            institutionName = try values.decodeIfPresent(String.self, forKey: .institution_name)
            accessToken = try values.decodeIfPresent(String.self, forKey: .access_token)
            publicToken = try values.decodeIfPresent(String.self, forKey: .public_token)
            isFirstTransactionsDumped = try values.decodeIfPresent(String.self, forKey: .is_first_transactions_dumped)
            addedAt = try values.decodeIfPresent(String.self, forKey: .added_at)
            status = try values.decodeIfPresent(String.self, forKey: .status)
            logo = try values.decodeIfPresent(String.self, forKey: .institution_logo)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(institutionId, forKey: .institution_id)
            try container.encode(institutionName, forKey: .institution_name)
            try container.encode(accessToken, forKey: .access_token)
            try container.encode(publicToken, forKey: .public_token)
            try container.encode(isFirstTransactionsDumped, forKey: .is_first_transactions_dumped)
            try container.encode(addedAt, forKey: .added_at)
            try container.encode(status, forKey: .status)
            try container.encode(logo, forKey: .institution_logo)
        }
    }
}



enum ResendLink {
    struct Request {
        var email: String
    }
   /// Reponse Class
    class ViewModel: WSResponseData {
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
        
        
        /// Init Method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
    }
}
