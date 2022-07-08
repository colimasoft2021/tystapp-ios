//
//  GlobalUtility.swift
//
//  Created by HiddenBrains on 14/07/16.
//
//

import UIKit
import Lottie
import DWAnimatedLabel
#if canImport(HBLogger)
import HBLogger
#endif

/// Utility class commonly used in the app
@objc class GlobalUtility: NSObject {
    
    
    
    /// Shared instance of the globalutility class
    static let shared: GlobalUtility = {
        let instance = GlobalUtility()
        // setup code
        return instance
    }()
    
    
    /// Show Progress view in the app
    static func showHud(message: String = "") {
        
        GlobalUtility.hideHud()
        let aStoryboard = UIStoryboard(name: "Loader", bundle: nil)
        let aVCObj = aStoryboard.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
        
        var window : UIWindow?
        aVCObj.strMessage = message
        window = AppConstants.appDelegate.window
        aVCObj.view.frame = UIScreen.main.bounds
        aVCObj.view.tag  = 10000
        
        window?.addSubview(aVCObj.view)
        
        
    }
    
    /// Hide Progress view in the app
    static func hideHud() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        var window : UIWindow?
        //        if #available(iOS 13.0, *) {
        //            window = AppConstants.scene?.window
        //        } else {
        window = AppConstants.appDelegate.window
        //}
        for view in (window?.subviews)!
        {
            if view.tag == 10000
            {
                view.removeFromSuperview()
            }
        }
    }
    
    /// Get Navigation bar Button
    ///
    /// - Parameters:
    ///   - target: Target for the button
    ///   - selector: Selector Method
    ///   - imageName: Image to be displayed
    ///   - renderMode: Render Mode
    ///   - tintColor: Tint Color for the button
    ///   - direction: Direction for the button
    /// - Returns: Returns the button instance
    class func getNavigationButtonItems(target: AnyObject, selector: Selector, imageName: String, renderMode:UIImage.RenderingMode? = .alwaysOriginal, tintColor:UIColor? = .black, direction:UIControl.ContentHorizontalAlignment? = .left) -> [UIBarButtonItem]? {
        if let image = UIImage(named: imageName) {
            let itemWidth = 30
            let viewMain: UIView = UIView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth))
            let btnLeft: WLButton = WLButton(type: .custom)
            btnLeft.contentHorizontalAlignment = direction!
            if let tint = tintColor {
                btnLeft.tintColor = tint
            }
            btnLeft.frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth)
            btnLeft.setImage(image.withRenderingMode(renderMode!), for: .normal)
            if let highlightedImage = UIImage(named: imageName + "_h") {
                btnLeft.setImage(highlightedImage, for: .highlighted)
            }
            btnLeft.addTarget(target, action: selector, for: .touchUpInside)
            viewMain.addSubview(btnLeft)
            let barBtnItem: UIBarButtonItem = UIBarButtonItem(customView: viewMain)
            let frontSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            frontSpacer.width = -2
            let arrBarButton = [frontSpacer, barBtnItem]
            return arrBarButton
        }
        return nil
    }
    
    /// Get current TopView controller
    ///
    /// - Returns: UIViewController
    func currentTopViewController() -> UIViewController {
        
        var topVC: UIViewController? = GlobalUtility.getRootViewController()
        
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    
    /// Redirect to login
    class func redirectToLogin()
    {
        if AppConstants.appType == LoginWith.email {
            // MARK: - Login With Email Setup
            if let loginVC = LoginEmailViewController.instance() {
                let vc = NavController.init(rootViewController: loginVC)
                GlobalUtility.setRootViewController(viewController: vc)
                
            }
        } else if AppConstants.appType == LoginWith.socialEmail {
            // MARK: - Social login With Email Setup
            if let loginVC = LoginEmailAndSocialViewController.instance() {
                let vc = NavController.init(rootViewController: loginVC)
                GlobalUtility.setRootViewController(viewController: vc)
                
            }
        }
    }
    
    
    /// Get Image with color
    ///
    /// - Parameters:
    ///   - color: Color of the Image
    ///   - size: Size Of the Image
    /// - Returns: UIImage object with color specified
    class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    class func setRootViewController(viewController:UIViewController)
    {
        if #available(iOS 13.0, *) {
            //   AppConstants.scene?.window?.rootViewController  = viewController
        } else {
            //  AppConstants.appDelegate.window?.rootViewController  = viewController
        }
        
        AppConstants.appDelegate.window?.rootViewController  = viewController
        
    }
    
    class func getRootViewController() -> UIViewController
    {
        if #available(iOS 13.0, *) {
            //  return  AppConstants.scene?.window?.rootViewController ?? UIViewController()
        } else {
            //   return  AppConstants.appDelegate.window?.rootViewController  ?? UIViewController()
        }
        
        return  AppConstants.appDelegate.window?.rootViewController  ?? UIViewController()
        
    }
    
    
    /// Get The Class name
    ///
    /// - Parameter obj: Pass the object
    /// - Returns: Returns the class name in string
    class func classNameAsString(obj: Any) -> String {
        //prints more readable results for dictionaries, arrays, Int, etc
        return String(describing: type(of: obj))
    }
    
    
    /// Round off text to two digit after decimal
    ///
    /// - Parameter value: Value of the string
    /// - Returns: Returns String value with two digit after decimal
    func roundOffTextTwoDigit(_ value:String?) -> String
    {
        // return  value!.count > 0 ? String(format: "%.2f",Float(value ?? "0")!) : ""
        
        
        if let valueNew = Double(value!) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "es_US")
            formatter.currencyCode = "USD"
            formatter.maximumFractionDigits = 2
            if let str = formatter.string(for: valueNew) {
                return str
            }
        }
        return ""
    }
    
    
    func roundOffTextTwoDigitValue(_ value:String?) -> String
    {
        return  value!.count > 0 ? String(format: "%.2f",Float(value ?? "0")!) : ""
    }
    
    
    
    class func logButtonEvent(functionName : String,file:String,name:String)
    {
        #if canImport(HBLogger)
        HBLogger.shared.LogEvent(function:functionName,file:file , name: name, description: "Button Event")
        #endif
    }
    
    class func logScreenEvent(file:String,name:String,description:String)
    {
        #if canImport(HBLogger)
        HBLogger.shared.LogEvent(file:file, name: name, description: description)
        #endif
    }
    
    class func setUser(user:String)
    {
        #if canImport(HBLogger)
        HBLogger.shared.setUser(user)
        #endif
    }
}
