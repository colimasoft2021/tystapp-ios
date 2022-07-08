//
//  PlaidAPICall.swift
//  Tyst
//
//  Created by hb on 03/12/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import LinkKit

#if canImport(HBLogger)
import HBLogger
import UIKit
#endif

protocol LinkOAuthHandling {
    var linkHandler: Handler? { get }
}

class PlaidAPICall: NSObject {
    
    static let sharedInstance = PlaidAPICall()
    var isFrom = ""
    
    var topViewController = UIViewController()
    
    var linkHandler: Handler?
    
    //addons
//    func update(publicToken: String) {
//        topViewController = UIViewController.topViewController(withRootViewController:GlobalUtility.getRootViewController()) as? BaseViewControllerWithAd ?? UIViewController()
//        let linkViewDelegate = self
//        let linkViewController = PLKPlaidLinkViewController(publicToken:
//        "\(publicToken)", delegate: linkViewDelegate)
//        if (UI_USER_INTERFACE_IDIOM() == .pad) {
//            linkViewController.modalPresentationStyle = .formSheet;
//        }
//        topViewController.present(linkViewController, animated: true)
//    }
    
    func createLinkTokenConfiguration() -> LinkTokenConfiguration {

        let linkToken = "123"

        // With custom configuration using a link_token
        var linkConfiguration = LinkTokenConfiguration(token: linkToken) { success in
            print("public-token: \(success.publicToken) metadata: \(success.metadata)")
            
            // Handle success, e.g. by storing publicToken with your service
            NSLog("Successfully linked account!\npublicToken: \(success.publicToken) \nmetadata: \(success.metadata)")
            //            self.handleSuccessWithToken(publicToken, metadata: metadata)
            var insId = ""
            var instName = ""
                
            let institution = success.metadata.institution
                
            insId = institution.id
            instName = institution.name
                                
            let transData:[String: String] = ["instName": instName, "insId": insId, "publicToken": success.publicToken]
                
            if self.isFrom == "Home" {
            NotificationCenter.default.post(name: NSNotification.Name("CallFromPlaidAPIHome"), object: nil, userInfo: transData)
            }else if self.isFrom == "GeneratePublicToken" {
                NotificationCenter.default.post(name: NSNotification.Name("GeneratePublicToken"), object: nil, userInfo: transData)
            }else {
            NotificationCenter.default.post(name: NSNotification.Name("CallFromPlaidAPI"), object: nil, userInfo: transData)
            }
        }
        
        linkConfiguration.onExit = { exit in
            if let error = exit.error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(exit.metadata)")
                self.handleError(error,
                                    metadata: exit.metadata.metadataJSON,
                                    linkSession: exit.metadata.linkSessionID,
                                    status: exit.metadata.status,
                                    institution: exit.metadata.institution,
                                    requestID: exit.metadata.requestID)
            }
            else {
                NSLog("Plaid link exited with metadata: \(exit.metadata)")
                self.handleExitWithMetadata(exit.metadata.metadataJSON)
            }
        }

        linkConfiguration.onEvent = { event in
            print("Link Event: \(event)")
            NSLog("Link event: \(event) \nmetadata: \(event.metadata)")
        }

        return linkConfiguration
    }
        
    func pladeApiConfiguration() {
        
        topViewController = UIViewController.topViewController(withRootViewController:GlobalUtility.getRootViewController()) as? BaseViewControllerWithAd ?? UIViewController()
        
        #if USE_CUSTOM_CONFIG
        presentPlaidLinkUsingLinkToken()
        //presentPlaidLinkWithCustomConfiguration()
        #else
        //presentPlaidLinkWithSharedConfiguration()
        #endif
    }
    
    func handleSuccessWithToken(_ publicToken: String, metadata: [String : Any]?) {
        presentAlertViewWithTitle("Success", message: "token: \(publicToken)\nmetadata: \(metadata ?? [:])")
    }
    
    func handleError(_ error: ExitError, metadata: Optional<String>, linkSession: String?, status: ExitStatus?, institution: Institution?, requestID: String?) {
        print("HANDLE ERROR")
        var msg = "\(error.localizedDescription)"
        msg += ", link_session_id: \(linkSession ?? "")"
        msg += ", status: \(status ?? ExitStatus.unknown(""))"
            
        var dictMsg = ""
            
        if let temp =  institution {
            dictMsg = ", name: \(temp.name)"
            dictMsg += ", institution_id: \(temp.id)"
        }
        msg += ", \(dictMsg)"
        msg += ", request_id: \(requestID ?? "")"
        
            
                /// HBLogger.shared.LogEvent(name: NotificationType.Error.rawValue, description: "error: \(msg)" ?? "")
    }
    
    func handleExitWithMetadata(_ metadata: Optional<String>) {
        print("EXIT metadata: \(metadata ?? "")")
    }
    
    func presentAlertViewWithTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        topViewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Plaid Link setup with shared configuration from Info.plist
//    func presentPlaidLinkWithSharedConfiguration() {
//        // <!-- SMARTDOWN_PRESENT_SHARED -->
//        // With shared configuration from Info.plist
//        let linkViewDelegate = self
//        let linkViewController = PLKPlaidLinkViewController(delegate: linkViewDelegate)
//        if (UI_USER_INTERFACE_IDIOM() == .pad) {
//            linkViewController.modalPresentationStyle = .formSheet
//        }
//        topViewController.present(linkViewController, animated: true)
//        // <!-- SMARTDOWN_PRESENT_SHARED -->
//    }
    
    // MARK: Plaid Link setup with custom configuration
//    func presentPlaidLinkWithCustomConfiguration() {
//        // <!-- SMARTDOWN_PRESENT_CUSTOM -->
//        // With custom configuration
//        let linkConfiguration = PLKConfiguration(key: AppConstants.plaidPublicKey, env: .sandbox, product: .transactions)
//
//        //        let linkConfiguration2 = PLKConfiguration(key: AppConstants.plaidPublicKey, env: .sandbox, product: .transactions, selectAccount: false, longtailAuth: true, apiVersion: .PLKAPILatest)
//
//
//        linkConfiguration.clientName = "Link Demo"
//        let linkViewDelegate = self
//        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
//        if (UI_USER_INTERFACE_IDIOM() == .pad) {
//            linkViewController.modalPresentationStyle = .formSheet
//        }
//        topViewController.present(linkViewController, animated: true)
//        // <!-- SMARTDOWN_PRESENT_CUSTOM -->
//    }
    
    // MARK: Start Plaid Link in update mode
//    func presentPlaidLinkInUpdateMode() {
//        // <!-- SMARTDOWN_UPDATE_MODE -->
//        let linkViewDelegate = self
//        let linkViewController = PLKPlaidLinkViewController(publicToken: "", delegate: linkViewDelegate)
//        if (UI_USER_INTERFACE_IDIOM() == .pad) {
//            linkViewController.modalPresentationStyle = .formSheet
//        }
//        topViewController.present(linkViewController, animated: true)
//        // <!-- SMARTDOWN_UPDATE_MODE -->
//    }
    
    // MARK: Start Plaid Link using a Link token
    func presentPlaidLinkUsingLinkToken() {
        let linkConfiguration = createLinkTokenConfiguration()
        let result = Plaid.create(linkConfiguration)
        switch result {
        case .failure(let error):
            print("Unable to create Plaid handler due to: \(error)")
        case .success(let handler):
            handler.open(presentUsing: .custom({ viewController in
                self.topViewController = viewController
            }, { viewController in
                self.topViewController = viewController
            }))
            self.linkHandler = handler
        }
    }
}
