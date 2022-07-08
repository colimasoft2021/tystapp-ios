//
//  ChangeTaxModels.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

enum ChangeTax {
    // MARK: Use cases
    
    class ViewModel: WSResponseData {
        var reason : String?
        var reason_id : String?
        var added_at : String?
        var updated_at : String?
        var status : String?
        
        enum CodingKeys: String, CodingKey {
            case reason = "reason"
            case reason_id = "reason_id"
            case added_at = "added_at"
            case updated_at = "updated_at"
            case status = "status"
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reason = try values.decodeIfPresent(String.self, forKey: .reason)
            reason_id = try values.decodeIfPresent(String.self, forKey: .reason_id)
            added_at = try values.decodeIfPresent(String.self, forKey: .added_at)
            updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
            status = try values.decodeIfPresent(String.self, forKey: .status)
        }
        
    }
    
    
}
