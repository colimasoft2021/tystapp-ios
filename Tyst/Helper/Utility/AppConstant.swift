//
//  AppConstant.swift
//  BaseProject
//
//  Created by hb on 27/08/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit


///Constants user in the app
struct AppConstants {
    
    /// App color
    static let appColor = UIColor(named: "AppColor")
    /// App Name
    static let appName = "TYST"
    /// App delegate object
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    
    @available(iOS 13.0, *)
    //    static let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    /// Screen width
    static let screenWidth = UIScreen.main.bounds.size.width
    /// screen height
    static let screenHeight = UIScreen.main.bounds.size.height
    
    /// Base URL for API
    static let baseUrl = ApiServer.production
    /// Base URL for Plaid API
    static let plaidUrl = ApiServer.sandbox
    /// Enable encryption for the api
    static var enableEncryption = false
    /// Enable checksum for the api
    static var enableChecksum = false
    /// Is debug mode on
    static let isDebug = true
    /// AES Encryption ket
    static let aesEncryptionKey = "CIT@WS!"
    /// Webservice checksum
    static let ws_checksum = "ws_checksum"
    
    /// Device vendor identifier
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString
    /// Device name
    static let device_name = UIDevice.current.name
    /// Device model
    static let device_model = UIDevice.modelName
    /// Plateform
    static let platform = "iOS"
    /// OS Verison
    static let os_version = UIDevice.current.systemVersion
    
    /// Access Token
    static var accessToken: String?
    /// Disable button color
    static let dissableButtonColor = #colorLiteral(red: 0.03921568627, green: 0.09411764706, blue: 0.3450980392, alpha: 0.5975462148)
    
    /// Date Format to be user in the app
    static let dobFormate = "MMM dd yyyy"
    /// Placeholder color for textfield
    static let placeholderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    /// Placeholder color for textfield
    static let textBackGroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5139661815)
    /// Login type
    static var appType = LoginWith.socialEmail
    /// Background color user in the app
    static let backgroundColor = UIColor(named: "BackgroundColor")
    
    /// Subscription id for IAP
    //    static let subscriptionId = "goadfree"
    static let subscriptionId = "premiumsubscription"
    static let appSharedSecret = "2c68d45f46bd4b4d95e640e5c0fa6829"
    /// Is login skipped
    static var isLoginSkipped = false
    
    //static let plaidPublicKey = "994f0a46d8e13a39afb2b9c5d4386f"
    
    static var taxPercentage = "0.0"
    
    static var extraTaxPercentage = 6.0
}

/// Struct for the api
struct ApiServer {
    /// Local url
    static let local = ""
    /// URL for staging
    static let staging = "http://tyst.projectspreview.net/WS/"
    /// URL for production
    //static let prodcution = "http://34.197.108.24/WS/"
    static let production =  "https://mobile.tystapp.com/WS/"
    
    static let sandbox = "https://sandbox.plaid.com/"
}

/// Ad Mob details
struct ADMobDetail {
    // Mark : Test Ids
    /// AD Unit id
    static let adUnitID = "ca-app-pub-3940256099942544/4411468910"
    /// AD Mob ID
    static let admodId = "ca-app-pub-3940256099942544/2934735716"

    
//    // Mark : Live Ids
//    /// AD Unit id
//    static let adUnitID = "ca-app-pub-5963823178389539/4198732056"
//    /// AD Mob ID
//    static let admodId = "ca-app-pub-5963823178389539/6633323708"
}

/// App Info
struct AppInfo {
    /// App Name
    static let kAppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? AppConstants.appName
    /// App Version
    static let kAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    /// App Build version
    static let kAppBuildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    /// App Bundle identifier
    static let kBundleIdentifier = Bundle.main.bundleIdentifier
    /// App Store ID
    static let kAppstoreID = "1480838689"
    /// Play store bundle id
    static let kAndriodAppId = "com.app.tyst"
}

/// Third Party SDK API Key and Credentials
struct ServiceApiKey {
    /// Google Keys
    struct Google {
        /// Client ID for google login
        static let kClientID = "539448343089-hnuvgs0n1ee08nma1ihcifjp2e4rosd1.apps.googleusercontent.com"
        ///Key for google places search
        //old
        //AIzaSyBD7jL0m7-m1T0xhR00teozg7YQDI6fXm0
        static let kGMSServicesAPIKey = "AIzaSyDR1bxczUZnCLuHJY4jKqnJFxtdnV4YEQ4"
    }
    
}

/// Social type
///
/// - facebook: Facebook
/// - google: Google
/// - none:none
enum SocialLoginType: String  {
    /// Facebook
    case facebook = "facebook"
    /// Google
    case google = "google"
    case apple = "apple"
    /// None
    case none = ""
}

/// Device Plateform
struct Platform {
    
    /// Check if app is tested on simulator
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }
}

/// Userdefaults key
struct UserDefaultsKey {
    /// Device Token Key
    static let deviceTokenKey = "deviceTokenKey"
    /// Webservice token Key
    static let ws_token = "ws_token"
    /// User Detail
    static let userDetail = "user_detail"
    /// Notification Enabled
    static let notificationEnable = "notification_enable"
    
    static let tutorial = "tutorial"
    static let tokrn = "auth_token"
    
}

//// Enable or Disable Print Log
//public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//    if AppConstants.isDebug == true {
//        let output = items.map { "\($0)" }.joined(separator: separator)
//        Swift.print(output, terminator: terminator)
//    }
//}

/// Position for the shadow
///
/// - top: Top
/// - bottom: Bottom
/// - full: Full
/// - line: Line
enum shadowPosition {
    /// - Position: Top
    case top
    /// - Position: bottom
    case bottom
    /// - Position: full
    case full
    /// - Position: line
    case line
}

/// Toast Notificaiton type
///
/// - Error: Error
/// - Success: Success
/// - Info: Info
enum NotificationType : String {
    /// - Type: Error
    case Error
    /// - Type: Success
    case Success
    /// - Type: Info
    case Info
}

/// Static page code
///
/// - privacyPolicy: PRivacy Polcy
/// - termsCondition: Terms and condition
/// - aboutUs: ABout Us
enum StaticPageCode: String {
    /// - Code: Privacy Policy
    case privacyPolicy = "privacypolicy"
    /// - Code: Terms And Conditions
    case termsCondition = "termsconditions"
    /// - Code: About US
    case aboutUs = "aboutus"
    
    case eula = "eula"
}


/// Login with
///
/// - email: Email
/// - phone: Phone
/// - socialEmail: Social Email
/// - socialPhone: Social Phone
enum LoginWith {
    /// - Login With: Email
    case email
    /// - Login With: Phone
    case socialEmail
    
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}


struct AppleKeychainKeys {
    
    static let userIdentifier = "userIdentifier"
    static let userFirstName = "userIFirstName"
    static let userLastName = "userLastName"
    static let userEmail = "userEmail"
    
}
