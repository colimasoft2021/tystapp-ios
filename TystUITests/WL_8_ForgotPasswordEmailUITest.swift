//
//  ForgotPasswordEmailUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 04/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_8_ForgotPasswordEmailUITest: TystUITests {
    
    func test1ForgotPasswordFlow() {
        
        app.tabBars.buttons["Settings"].tap()
        wait(for: delay)
              
        app.buttons["Logout"].tap()
        wait(for: delay)
        app.alerts[appName].buttons["Yes"].tap()
        wait(for: apiDelay)
        
        let validEmail = "test@grr.la"
        
        snapshot("8.0.1LoginScreen",timeWaitingForIdle: 3)
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Forgot Password?"].tap()
        
        snapshot("8.0.2ForgotPasswordScreen",timeWaitingForIdle: 3)
        
        let nextButton = elementsQuery.buttons["Reset Password"]
        nextButton.tap()
        
        snapshot("8.0.3EmptyEmail",timeWaitingForIdle: 3)
        
        wait(for: delay)
        
        // Wrong Formatted email address
        self.tapAction(key: "mango")
        
        nextButton.tap()
        
        snapshot("8.0.4InValidEmail",timeWaitingForIdle: 3)
        
        wait(for: delay)
        
        self.deleteKey(value: 5, type: "delete")
        wait(for: delay)
        
        // Proper Formatted email address with wrong credentials
        self.tapAction(key: "mango@grr.la")
        
        nextButton.tap()
        
        snapshot("8.0.4EmailNotFound",timeWaitingForIdle: 3)
        
        wait(for: delay)
        
        self.deleteKey(value: 12, type: "delete")
        
        // Correct credentials
        self.tapAction(key: validEmail)
        
        nextButton.tap()
        wait(for: delay)
        snapshot("8.0.5Success",timeWaitingForIdle: 10)
        wait(for: apiDelay)
    }
}
