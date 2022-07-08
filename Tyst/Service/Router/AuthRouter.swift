//
//  LoginRouter.swift
//  Note
//
//  Created by HB1 on 28/09/18.
//  Copyright © 2018 HB. All rights reserved.
//
import Foundation
import Alamofire

/// Auth router mainly used for login and sign up
enum AuthRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Login with email Case
    case loginWithEmail(email: String, password: String)
    /// Login with phone Case
    
    case socialLogin(socialLoginType: String, socialLoginId: String)
    /// Sign up with email Case
    case signUpWithEmail(request: SignUp.SignUpEmailModel.Request)
    /// Sig nup with phone Case
    
    case checkUniqueUser(request: CheckUniqueUser.Request)
    /// Social Sign up Case
    case socialSignUp(request: SignUp.SignUpSocialModel.Request)
    /// State List Case
    case stateList
    /// Version check Case
    case versionCheck
    
    case updateToken(request : String)
    case subscriptionStatus
    case ResendLink(request: ResendLink.Request )
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .loginWithEmail:
            return "user_login_email"
        case .socialLogin:
            return "social_login"
        case .signUpWithEmail:
            return "user_sign_up_email"
        case .checkUniqueUser:
            return "/check_unique_user"
        case .socialSignUp:
            return "/social_sign_up"
        case .stateList:
            return "/states_list"
        case .versionCheck:
            return "/get_config_paramaters"
            
        case .updateToken:
            return "/update_device_token"
        case .subscriptionStatus:
            return "/get_subscription_status"
            
        case .ResendLink:
            return "/send_verification_link"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .loginWithEmail(let email, let password):
            params = [
                "email": email,
                "password": password,
                "device_type": AppConstants.platform,
                "device_model": AppConstants.device_model,
                "device_os": AppConstants.os_version,
                "device_token": UserDefaultsManager.deviceToken,
                "api_version": "1.1"
            ]
            
            
        case .socialLogin(let type, let id):
            params = [
                "social_login_type": type,
                "social_login_id": id,
                "device_type": AppConstants.platform,
                "device_model": AppConstants.device_model,
                "device_os": AppConstants.os_version,
                "device_token": UserDefaultsManager.deviceToken
            ]
            
        case .signUpWithEmail(let request):
            params = [
                "first_name": request.firstName,
                "last_name": request.lastName,
                "user_name": request.userName,
                "email": request.email,
                "mobile_number": request.mobileNo,
                "user_profile": request.userProfile,
                "dob": request.dob,
                "password": request.password,
                "address": request.address,
                "city": request.city,
                "latitude": request.lat,
                "longitude": request.long,
                "state_id": request.stateId,
                "zipcode": request.zipCode,
                "device_type": AppConstants.platform,
                "device_token": UserDefaultsManager.deviceToken,
                "device_model": AppConstants.device_model,
                "device_os": AppConstants.os_version,
                "api_version": "1.1"
            ]
            
            
        case .checkUniqueUser(let request):
            return [
                "mobile_number": request.phone,
                "email": request.email,
                "type": "phone",
                "user_name": request.userName
            ]
            
        case .socialSignUp(let request):
            params = [
                "first_name": request.firstName,
                "last_name": request.lastName,
                "user_name": request.userName,
                "email": request.email,
                "mobile_number": request.mobileNo,
                "user_profile": request.userProfile,
                "dob": request.dob,
                "address": request.address,
                "city": request.city,
                "latitude": request.lat,
                "longitude": request.long,
                "state_id": request.stateId,
                "zipcode": request.zipCode,
                "device_type": AppConstants.platform,
                "social_login_type": request.socialLoginType,
                "social_login_id": request.socialId,
                "device_token": UserDefaultsManager.deviceToken,
                "device_model": AppConstants.device_model,
                "device_os": AppConstants.os_version
            ]
            
        case .stateList:
            params = [:]
            
        case .versionCheck:
            params = [:]
            
        case .updateToken( _):
            return [
                "user_id": UserDefaultsManager.getLoggedUserDetails()?.userInfo![0].userId ?? "",
                "user_access_token": UserDefaultsManager.getLoggedUserDetails()?.userInfo![0].authToken ?? "",
                "device_token" : UserDefaultsManager.deviceToken
            ]
            
        case .subscriptionStatus:
            params = [:]
            
        case .ResendLink(let request):
            return [
                
                "email": request.email
                
            ]
        }
        
        
        return params
    }
    
    /// Parameter Encoding required
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    /// Headers for the url request
    var headers: [String: String]? {
        switch self {
        case .subscriptionStatus, .versionCheck :
            return ["Content-Type": "application/x-www-form-urlencoded", "AUTHTOKEN": UserDefaultsManager.authToken]
        default:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    /// Files if required to attach
    var files: [MultiPartData]? {
        switch self {
        case .signUpWithEmail(let request):
            var arrMultiPart = [MultiPartData]()
            arrMultiPart.append(MultiPartData(fileName: request.userProfileName, data: request.userProfile, paramKey: "user_profile", mimeType: request.userProfileName.fileExtension(), fileKey: "user_profile"))
            return arrMultiPart
            
            
            
        case .loginWithEmail:
            return nil
            
            
        case .checkUniqueUser:
            return nil
            
        case .socialLogin:
            return nil
            
        case .stateList:
            return nil
            
        case .versionCheck:
            return nil
            
        case .socialSignUp(let request):
            var arrMultiPart = [MultiPartData]()
            arrMultiPart.append(MultiPartData(fileName: request.userProfileName, data: request.userProfile, paramKey: "user_profile", mimeType: request.userProfileName.fileExtension(), fileKey: "user_profile"))
            return arrMultiPart
            
        case .updateToken:
            return nil
            
        case .subscriptionStatus:
            return nil
            
        case .ResendLink:
            return nil
            
        }
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
