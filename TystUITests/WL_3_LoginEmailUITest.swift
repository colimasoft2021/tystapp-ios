//
//  The_AppineersUITests.swift
//  The AppineersUITests
//
//  Created by hb on 01/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_3_LoginEmailUITest: TystUITests {
    
    lazy var loginButton = elementsQuery.buttons["Login"]
    
    //Invalid credentials:
    //test@grr.la pass. Qwerty
    //Valid credentials:
    //white@label.com pass. Qwerty123
    
    let email = "test@grr.la"
    
     
    func test1EmailValidiations() {
        

        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let loginButton = elementsQuery.buttons["Login"]
        loginButton.tap()
        
        let emailTextField = elementsQuery.textFields["Email"]
        emailTextField.tap()
        
        let wKey = app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        wKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["h"]/*[[".keyboards.keys[\"h\"]",".keys[\"h\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wKey.tap()
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        loginButton.tap()
        emailTextField.tap()
        
        let key = app/*@START_MENU_TOKEN@*/.keys["@"]/*[[".keyboards.keys[\"@\"]",".keys[\"@\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        
        let gKey = app/*@START_MENU_TOKEN@*/.keys["g"]/*[[".keyboards.keys[\"g\"]",".keys[\"g\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        gKey.tap()
        
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        rKey.tap()
        
        let key2 = app/*@START_MENU_TOKEN@*/.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()
        
        let lKey = app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        lKey.tap()

        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()

        doneButton.tap()
        loginButton.tap()
        
        
        
        
        
    }
    
    func test2PasswordValidiations() {
        
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: "whitee@label.com")
        

        elementsQuery.secureTextFields["Password"].tap()
        
        app.buttons["shift"].tap()
        app/*@START_MENU_TOKEN@*/.keys["Q"]/*[[".keyboards.keys[\"Q\"]",".keys[\"Q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "werty")
        

        loginButton.tap()
        snapshot("3.4LoginInvalidPasswordValidation",timeWaitingForIdle: 3)

        wait(for: delay)
        

    }
    
    func test3Login() {
         wait(for: delay)
        
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        elementsQuery.secureTextFields["Password"].tap()
        app.buttons["shift"].tap()
        app.keys["T"].tap()
        self.tapAction(key: "est")
        self.getKey(key: "more").tap()
        self.tapAction(key: "12345")
        
        loginButton.tap()
        snapshot("3.5LoginSuccess",timeWaitingForIdle: 10)

        wait(for: apiDelay)
        
    }
    
    func test4Logout() {
        wait(for: delay)
        app.tabBars.buttons["Settings"].tap()
        app.buttons["Logout"].tap()
        wait(for: delay)
        
        snapshot("3.6LogoutAlert",timeWaitingForIdle: 3)
        
        app.alerts[appName].buttons["Yes"].tap()
        
        snapshot("3.7LogoutSuccess",timeWaitingForIdle: 3)
        
        wait(for: apiDelay)
        
    }
}
