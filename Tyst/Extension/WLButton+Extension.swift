//
//  WLButton+Extension.swift
//  WhiteLabelApp
//
//  Created by hb on 17/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension WLButton {
    /// Check if button is selected
    ///
    /// - Throws: Throws exception if button is not selected
    func checkSelection() throws {
        if !self.isSelected {
            throw ValidationError(AlertMessage.acceptTermsCondition)
        }
    }
    
    
}
