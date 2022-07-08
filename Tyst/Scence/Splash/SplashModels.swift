//
//  SplashModels.swift
//  Test
//
//  Created by hb on 11/10/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

struct Splash {
    
   /// Reponse Class
    class ViewModel: WSResponseData {
        
        var versionUpdateCheck: String?
        var androidVersion : String?
        var iosVersion : String?
        var versionUpdateOptional : String?
        var alertMessage : String?
        var taxPercentage: String?
        var termsConditionUpdate: String?
        var privacyPolicyUpdate: String?
        
        /// Enum for response
        ///
        /// - version_update_check: Version check param
        /// - android_version_number: android version number
        /// - iphone_version_number: iphone version number
        /// - version_update_optional: version update option check
        /// - version_check_message: version check message
        enum CodingKeys: String, CodingKey {
            /// - version_update_check: Version check param
            case version_update_check
            /// - android_version_number: android version number
            case android_version_number
            /// - iphone_version_number: iphone version number
            case iphone_version_number
            /// - version_update_optional: version update option check
            case version_update_optional
            /// - version_check_message: version check message
            case version_check_message
            case maximum_tax_perc
            case terms_conditions_updated
            case privacy_policy_updated
        }
        
        /// Init default method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            versionUpdateCheck = try values.decodeIfPresent(String.self, forKey: .version_update_check)
            androidVersion = try values.decodeIfPresent(String.self, forKey: .android_version_number)
            iosVersion = try values.decodeIfPresent(String.self, forKey: .iphone_version_number)
            versionUpdateOptional = try values.decodeIfPresent(String.self, forKey: .version_update_optional)
            alertMessage = try values.decodeIfPresent(String.self, forKey: .version_check_message)
            taxPercentage = try values.decodeIfPresent(String.self, forKey: .maximum_tax_perc)
            termsConditionUpdate = try values.decodeIfPresent(String.self, forKey: .terms_conditions_updated)
            privacyPolicyUpdate = try values.decodeIfPresent(String.self, forKey: .privacy_policy_updated)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(versionUpdateCheck, forKey: .version_update_check )
            try container.encode(androidVersion, forKey: .android_version_number)
            try container.encode(iosVersion, forKey: .iphone_version_number)
            try container.encode(versionUpdateOptional, forKey: .version_update_optional)
            try container.encode(alertMessage, forKey: .version_check_message)
            try container.encode(taxPercentage, forKey: .maximum_tax_perc)
            try container.encode(termsConditionUpdate, forKey: .terms_conditions_updated)
            try container.encode(privacyPolicyUpdate, forKey: .privacy_policy_updated)
        }
    }
}
