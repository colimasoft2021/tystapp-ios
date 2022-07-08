//
//  File.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//


import Foundation
import UIKit
import Photos
import MessageUI
import SKPhotoBrowser
import SwiftMessages
import FirebaseAnalytics
#if canImport(HBLogger)
import HBLogger
#endif

extension UIViewController: SKPhotoBrowserDelegate  {
    /// Display Alert with options Yes or No
    ///
    /// - Parameters:
    ///   - msg: Message to be displayed in the alert
    ///   - ok: Text for Ok
    ///   - cancel: Text for cancel
    ///   - okAction:  Closure To do after user clicks OK
    ///   - cancelAction: Closure To do after user clicks Cancel
    func displayAlert( msg: String?, ok: String, cancel: String, okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil){
        
        let alertController = UIAlertController(title:  AppInfo.kAppName, message: msg, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel)
        { (action) in
            if let cancelAction = cancelAction {
                DispatchQueue.main.async(execute: {
                    cancelAction()
                })
            }
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: ok, style: .default)
        { (action) in
            if let okAction = okAction {
                DispatchQueue.main.async(execute: {
                    okAction()
                })
            }
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayAlertSingleOption( msg: String?, ok: String, okAction: (() -> Void)? = nil){
        let alertController = UIAlertController(title:  AppInfo.kAppName, message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: ok, style: .default)
        { (action) in
            if let okAction = okAction {
                DispatchQueue.main.async(execute: {
                    okAction()
                })
            }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    /// Call Option
    ///
    /// - Parameter phoneNumber: Phone Number
    func callNumber(phoneNumber:String) {
        if !phoneNumber.isEmpty {
            let aNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            if let phoneCallURL:URL = URL(string:"tel://\(aNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL )) {
                    if #available(iOS 10, *) {
                        application.open(phoneCallURL , options: [:], completionHandler: nil)
                    } else {
                        application.openURL(phoneCallURL);
                    }
                }
            }
        }
    }
    
    //topViewController function helps to find top most controller
    /// topViewController function helps to find top most controller
    ///
    /// - Parameter rootViewController: RootViewController of the window
    /// - Returns: TopView controller in the heirarchy
    class func topViewController(withRootViewController rootViewController: UIViewController) -> UIViewController {
        if (rootViewController is UITabBarController) {
            let tabBarController = (rootViewController as! UITabBarController)
            return self.topViewController(withRootViewController: tabBarController.selectedViewController!)
        }
        else if (rootViewController is UINavigationController) {
            let navigationController = (rootViewController as! UINavigationController)
            return self.topViewController(withRootViewController: navigationController.visibleViewController!)
        }
        else if (rootViewController.presentedViewController != nil) {
            let presentedViewController = rootViewController.presentedViewController
            return self.topViewController(withRootViewController: presentedViewController!)
        }
        else {
            return rootViewController
        }
    }
    
   
    
    /// Mail composer did finish the work
    ///
    /// - Parameters:
    ///   - controller: Mail Controller object
    ///   - result: Mail result
    ///   - error: Error
    @objc(mailComposeController:didFinishWithResult:error:) func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // This function add google analytics
     /// Add Google Analytics
     ///
     /// - Parameters:
     ///   - analyticsParameterItemID: analyticsParameterItemID
     ///   - analyticsParameterItemName: analyticsParameterItemName
     ///   - analyticsParameterContentType: analyticsParameterContentType
    func addAnayltics(analyticsParameterItemID: String, analyticsParameterItemName: String,  analyticsParameterContentType: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: analyticsParameterItemID,
            AnalyticsParameterItemName: analyticsParameterItemName,
            AnalyticsParameterContentType: analyticsParameterContentType
            ])
    }
 
    
    
    
    /// Show message below navigationbar
    ///
    /// - Parameters:
    ///   - message: Message to be displayed
    ///   - type: Type of Message
    func showTopMessage(message : String?, type : NotificationType, displayDuration: Double = 2) {
       
        if let _ = message {
           // HBLogger.shared.LogEvent(name: type.rawValue, description: message ?? "")
            let view: MessageView = MessageView.viewFromNib(layout: .cardView)
            
            var config = SwiftMessages.defaultConfig
            
            view.configureTheme(type == .Success ? .success : .error )
            
            config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            config.duration = .seconds(seconds: displayDuration)
            config.dimMode = .none
            
            config.interactiveHide = true
            view.iconImageView?.isHidden = true
            view.iconLabel?.isHidden = true
            view.button?.isHidden = true
            view.titleLabel?.text = AppInfo.kAppName
            view.bodyLabel?.text = message
            
            view.configureDropShadow()
            
            config.preferredStatusBarStyle = .lightContent
            
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    func changeColor(image: UIImage, color: UIColor, button: UIButton) {
        let image = image.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = color
        button.tintAdjustmentMode = .normal
    }
    
    
    func showImageDetailView(arrImage: [String], currentImage: Int = 0) {
        var images = [SKPhoto]()
        _ = arrImage.map {
            let photo = SKPhoto.photoWithImageURL($0)
            photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
            images.append(photo)
        }
        
        let browser = SKPhotoBrowser(photos: images)
        browser.delegate = self
        SKPhotoBrowserOptions.displayAction = false
        browser.initializePageIndex(currentImage)
        present(browser, animated: true, completion: {})
    }
}
