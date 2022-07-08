//
//  ExpenseListModels.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

enum ExpenseList {
    // MARK: Use cases
    
    struct Request {
        var startDate: String
        var endDate: String
        var searchKeyword: String
        var instutionId: String
        var accountId: String
        var pageIndex: Int
    }
    
    /// Reponse Class
    class ViewModel: WSResponseData {
        var transctionData: [TransactionData]?
        var totalAmount: [TotalAmount]?
        
        enum CodingKeys: String, CodingKey {
            case transactions_data
            case total_amount
        }
        
        /// Init default method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            transctionData = try values.decodeIfPresent([TransactionData].self, forKey: .transactions_data)
            totalAmount = try values.decodeIfPresent([TotalAmount].self, forKey: .total_amount)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(transctionData, forKey: .transactions_data)
            try container.encode(totalAmount, forKey: .total_amount)
        }
        
        class TransactionData: Codable {
            let store_name : String?
            let category : String?
            let transaction_date : String?
            let transaction_amount : String?
            let tax_amount : String?
            let transaction_id : String?
            let location : String?
            let zip_code : String?
            let taxperc : String?
            let is_modified_transaction : String?
            let added_at : String?
            let updated_at : String?
            let status : String?
            let state_id : String?
            let latitude : String?
            let longitude : String?
            let pay_by_cash : String?
            let access_token : String?
            let state : String?
            let user_id : String?
            let account_id : String?
            let receipt_image : String?
            let t_transaction_id : String?
            let institution_name : String?
            let institution_id : String?
            let account_name: String?
            
            let reasonId: String?
            let changedTaxAmount: String?
            let reasonText: String?
            
            enum CodingKeys: String, CodingKey {
                
                case store_name = "store_name"
                case category = "category"
                case transaction_date = "transaction_date"
                case transaction_amount = "transaction_amount"
                case tax_amount = "tax_amount"
                case transaction_id = "transaction_id"
                case location = "location"
                case zip_code = "zip_code"
                case taxperc = "taxperc"
                case is_modified_transaction = "is_modified_transaction"
                case added_at = "added_at"
                case updated_at = "updated_at"
                case status = "status"
                case state_id = "state_id"
                case latitude = "latitude"
                case longitude = "longitude"
                case pay_by_cash = "pay_by_cash"
                case access_token = "access_token"
                case state = "state"
                case user_id = "user_id"
                case account_id = "account_id"
                case receipt_image = "receipt_image"
                case t_transaction_id = "t_transaction_id"
                case institution_name = "institution_name"
                case institution_id = "institution_id"
                case account_name = "account_name"
        
                case reasonId = "reason_id"
                case changedTaxAmount = "changed_tax_amount"
                case reasonText = "reason_text"
            }
            
            required public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                store_name = try values.decodeIfPresent(String.self, forKey: .store_name)
                category = try values.decodeIfPresent(String.self, forKey: .category)
                transaction_date = try values.decodeIfPresent(String.self, forKey: .transaction_date)
                transaction_amount = try values.decodeIfPresent(String.self, forKey: .transaction_amount)
                tax_amount = try values.decodeIfPresent(String.self, forKey: .tax_amount)
                transaction_id = try values.decodeIfPresent(String.self, forKey: .transaction_id)
                location = try values.decodeIfPresent(String.self, forKey: .location)
                zip_code = try values.decodeIfPresent(String.self, forKey: .zip_code)
                taxperc = try values.decodeIfPresent(String.self, forKey: .taxperc)
                is_modified_transaction = try values.decodeIfPresent(String.self, forKey: .is_modified_transaction)
                added_at = try values.decodeIfPresent(String.self, forKey: .added_at)
                updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
                latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
                longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
                pay_by_cash = try values.decodeIfPresent(String.self, forKey: .pay_by_cash)
                access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
                state = try values.decodeIfPresent(String.self, forKey: .state)
                user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
                account_id = try values.decodeIfPresent(String.self, forKey: .account_id)
                receipt_image = try values.decodeIfPresent(String.self, forKey: .receipt_image)
                t_transaction_id = try values.decodeIfPresent(String.self, forKey: .t_transaction_id)
                institution_name = try values.decodeIfPresent(String.self, forKey: .institution_name)
                institution_id = try values.decodeIfPresent(String.self, forKey: .institution_id)
                account_name = try values.decodeIfPresent(String.self, forKey: .account_name)
                
                reasonId = try values.decodeIfPresent(String.self, forKey: .reasonId)
                changedTaxAmount = try values.decodeIfPresent(String.self, forKey: .changedTaxAmount)
                reasonText = try values.decodeIfPresent(String.self, forKey: .reasonText)
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



