//
//  SettingModels.swift
//  WhiteLabelApp
//
//  Created by hb on 23/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Settings Request and Reponse
enum Setting {
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

/// Update Push notification settings
enum UpdatePushNotificationSetting {
    /// Struct for API Request
    struct Request {
        /// Notification Param
        var notification: String
    }
}

/// Enum for go ad free
enum GoAddFree {
    /// Struct for API Request
    struct Request {
        /// One time Transaction Data Receipt
        var oneTimeTransactionData: String
    }
}
