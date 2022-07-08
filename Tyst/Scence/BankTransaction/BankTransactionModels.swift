//
//  BankTransactionModels.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

enum BankTransaction {
    struct Request{
        var transId: String
    }
    /// Reponse Class
    class ViewModel: WSResponseData {
        var t_transactions_id : String?
        var category : String?
        var store_name : String?
        var location : String?
        var transaction_date : String?
        var transaction_amount : String?
        var tax_amount : String?
        var tip_amount : String?
        var transaction_id : String?
        var receipt_image : [String]?
        var reason : String?
        var reason_id : String?
        var tipPercentage: String?
        var taxPercentage: String?
        var changedTaxAmount: String?
        
        
        enum CodingKeys: String, CodingKey {
            case t_transactions_id = "t_transactions_id"
            case category = "category"
            case store_name = "store_name"
            case location = "location"
            case transaction_date = "transaction_date"
            case transaction_amount = "transaction_amount"
            case tax_amount = "tax_amount"
            case tip_amount = "tip_amount"
            case transaction_id = "transaction_id"
            case receipt_image = "receipt_images"
            case reason = "reason"
            case reason_id = "reason_id"
            case tipPercentage = "tip_perc"
            case taxPercentage = "taxperc"
            case changedTaxAmount = "changed_tax_amount"
        }
        
        /// Init default method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            t_transactions_id = try values.decodeIfPresent(String.self, forKey: .t_transactions_id)
            category = try values.decodeIfPresent(String.self, forKey: .category)
            store_name = try values.decodeIfPresent(String.self, forKey: .store_name)
            location = try values.decodeIfPresent(String.self, forKey: .location)
            transaction_date = try values.decodeIfPresent(String.self, forKey: .transaction_date)
            transaction_amount = try values.decodeIfPresent(String.self, forKey: .transaction_amount)
            tax_amount = try values.decodeIfPresent(String.self, forKey: .tax_amount)
            tip_amount = try values.decodeIfPresent(String.self, forKey: .tip_amount)
            transaction_id = try values.decodeIfPresent(String.self, forKey: .transaction_id)
            receipt_image = try values.decodeIfPresent([String].self, forKey: .receipt_image)
            reason = try values.decodeIfPresent(String.self, forKey: .reason)
            reason_id = try values.decodeIfPresent(String.self, forKey: .reason_id)
            tipPercentage = try values.decodeIfPresent(String.self, forKey: .tipPercentage)
            taxPercentage = try values.decodeIfPresent(String.self, forKey: .taxPercentage)
            changedTaxAmount = try values.decodeIfPresent(String.self, forKey: .changedTaxAmount)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(t_transactions_id, forKey: .t_transactions_id)
            try container.encode(category, forKey: .category)
            try container.encode(store_name, forKey: .store_name)
            try container.encode(location, forKey: .location)
            try container.encode(transaction_date, forKey: .transaction_date)
            try container.encode(transaction_amount, forKey: .transaction_amount)
            try container.encode(tax_amount, forKey: .tax_amount)
            try container.encode(tip_amount, forKey: .tip_amount)
            try container.encode(transaction_id, forKey: .transaction_id)
            try container.encode(receipt_image, forKey: .receipt_image)
            try container.encode(reason, forKey: .reason)
            try container.encode(reason_id, forKey: .reason_id)
            try container.encode(tipPercentage, forKey: .tipPercentage)
            try container.encode(taxPercentage, forKey: .taxPercentage)
            try container.encode(changedTaxAmount, forKey: .changedTaxAmount)
        }
       
    }
}

enum AddTip {
    struct Request {
        var transId: String
        var tipAmount: String
    }
    class ViewModel: WSResponseData {
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
    }
}


enum ChangeTaxAmount {
    struct Request {
        var transId: String
        var taxAmount: String
        var reasonId: String
    }
    class ViewModel: WSResponseData {
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
    }
}


enum DeleteTransaction {
    struct Request {
        var transId: String
    }
    class ViewModel: WSResponseData {
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
    }
}


enum UpdateCategory {
    struct Request {
        var transId: String
        var categoryId: String
        var categoryName: String
    }
    class ViewModel: WSResponseData {
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
    }
}
