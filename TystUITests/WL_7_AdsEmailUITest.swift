//
//  AdsUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 07/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_7_AdsEmailUITest: TystUITests {
    
    func test1DisplayBeforeRemove() {
        wait(for: delay)
        
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        app.scrollViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).buttons["dropdown arrow s 10"].tap()
        snapshot("7.0.1ShowAdsScreenWithAds",timeWaitingForIdle: 3)
        
    }
    
    func test2RemoveAds() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).buttons["dropdown arrow s 10"].tap()
        scrollViewsQuery.otherElements.buttons["Buy for $9.99 a month"].tap()
        wait(for: delay)
        snapshot("7.0.2AlertForRemoveAds",timeWaitingForIdle: 3)
        
        app.alerts["TYST"].scrollViews.otherElements.buttons["Buy for $9.99"].tap()
      
        snapshot("7.0.3RemoveAds",timeWaitingForIdle: 2)
        wait(for: apiDelay)
        
    }
    
}
