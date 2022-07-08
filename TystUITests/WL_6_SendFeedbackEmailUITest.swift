//
//  SendFeedbackUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 07/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_6_SendFeedbackEmailUITest: TystUITests {
    
    func test1SendFeedback() {
        
        let app = XCUIApplication()

        let app2 = app
        app.tabBars.buttons["Settings"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["Support"].swipeUp()
        scrollViewsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 4).children(matching: .other).element(boundBy: 5).buttons["dropdown arrow s 10"].tap()
        
        let sendButton = elementsQuery.buttons["Send"]
        sendButton.tap()
        
        wait(for: delay)
        snapshot("6.0.1SendFeedScreen",timeWaitingForIdle: 3)
        
        
        scrollViewsQuery.otherElements.containing(.image, identifier:"login_logo").children(matching: .textView).element.tap()
        app2/*@START_MENU_TOKEN@*/.keys["L"]/*[[".keyboards.keys[\"L\"]",".keys[\"L\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app2.keys["o"].tap()
        app2.keys["r"].tap()
        app2.keys["e"].tap()
        app2.keys["a"].tap()
        
        
        let spaceKey = app2/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        spaceKey.tap()
        
        
        app2.keys["i"].tap()
        app2.keys["p"].tap()
        app2.keys["s"].tap()
        app2.keys["u"].tap()
        app2.keys["m"].tap()
        
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        sendButton.tap()
        
        snapshot("6.0.3Success",timeWaitingForIdle: 10)
        wait(for: apiDelay)
        wait(for: delay)
                
    
    }
    
    
    
}
