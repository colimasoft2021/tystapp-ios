//
//  NetworkService.swift
//  Note
//
//  Created by HB1 on 28/09/18.
//  Copyright © 2018 HB. All rights reserved.
//

import Foundation
import Alamofire

#if canImport(HBLogger)
import HBLogger
#endif


public protocol NetworkProtocol {
    static func dataRequest<Model: WSResponseData>(with request: RouterProtocol, showHud:Bool, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void)
    static func tokenCreationDataRequest(with request: RouterProtocol, completionHandler: @escaping (Data?, Error?) -> Void)
}

final class NetworkService {
    private init() {}
    
    static let boundaryConstant = "aRandomBoundary1837440"
    
    private static let manager: SessionManager = { () -> SessionManager in
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()
    
}

extension NetworkService: NetworkProtocol {
    
    static private func encryptedParamsWithCheckSum(params: [String: Any]) -> [String: Any] {
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var input_sha = ""
        var outputParams = [String: Any]()
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if key == UserDefaultsKey.ws_token {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                    outputParams[key] = strVal
                } else if strVal == "FILE" {
                    input_sha = "\(input_sha)\(key)="
                } else {
                    ////                    let encryptedVal = AESCrypt.encrypt(strVal, password: AppConstants.aesEncryptionKey, isPreviewApp: false)
                    //                    input_sha = "\(input_sha)\(key)=\(encryptedVal!)"
                    //                    outputParams[key] = encryptedVal
                }
            } else {
                input_sha = "\(input_sha)\(key)="
                outputParams[key] = params[key]
            }
        }
        //        if let sha1_val = AESCrypt.getSHA1(input_sha) {
        //            outputParams[AppConstants.ws_checksum] = sha1_val
        //        }
        return outputParams
    }
    
    static private func encryptedParams(params: [String: Any]) -> [String: Any] {
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var outputParams = [String: Any]()
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if key == UserDefaultsKey.ws_token {
                    outputParams[key] = strVal
                } else if strVal == "FILE" {
                }
                //                } else {
                //                    let encryptedVal = AESCrypt.encrypt(strVal, password: AppConstants.aesEncryptionKey, isPreviewApp: false)
                //                    outputParams[key] = encryptedVal
                //                }
            } else {
                outputParams[key] = params[key]
            }
        }
        return outputParams
    }
    
    static private func checkSum(of params: [String: Any]) -> [String: Any] {
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var input_sha = ""
        let outputParams = params
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if key == UserDefaultsKey.ws_token {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                } else if strVal == "FILE" {
                    input_sha = "\(input_sha)\(key)="
                } else {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                }
            } else {
                input_sha = "\(input_sha)\(key)="
            }
        }
        //        if let sha1_val = AESCrypt.getSHA1(input_sha) {
        //            outputParams[AppConstants.ws_checksum] = sha1_val
        //        }
        return outputParams
    }
    
    static func dataRequest<Model: WSResponseData>(with inputRequest: RouterProtocol, showHud:Bool = true, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void) {
        
        var finalParams = [String:Any]()
        let aRequestDate = Date()
        
        print("ROUTER BASE", inputRequest.baseUrlString)
        print("ROUTER PARAMETERS", inputRequest.parameters ?? [:])
        print("ROUTER PATH", inputRequest.path)
        print("ROUTER VERB", inputRequest.method)
        
        if !(NetworkReachabilityManager()!.isReachable) {
            let aVC = GlobalUtility.getRootViewController()
            aVC.showTopMessage(message: AlertMessage.InternetError, type: .Error)
            return
        }
        
        if showHud {
            GlobalUtility.showHud()
        }
        
        do {
            _ = try inputRequest.asURLRequest()
        } catch {
            GlobalUtility.hideHud()
            completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
            return
        }
        
        manager.upload(multipartFormData: { (multiPartData) in
            var reqParam = inputRequest.parameters ?? [String: Any]()
            if let deviceInfo = inputRequest.deviceInfo {
                reqParam = reqParam.merging(deviceInfo) { (_, new) in new }
            }
            if let files = inputRequest.files {
                for file in files {
                    multiPartData.append(file.data, withName: file.paramKey, fileName: file.fileName, mimeType: file.mimeType)
                    reqParam[file.paramKey] = "FILE"
                }
            }
            print("PRE ENCRYPT : \(reqParam)")
            finalParams = ((AppConstants.enableEncryption && AppConstants.enableChecksum) ? encryptedParamsWithCheckSum(params: reqParam) : (AppConstants.enableEncryption ? encryptedParams(params: reqParam) : (AppConstants.enableChecksum ? checkSum(of: reqParam) : reqParam)))
            print("POST ENCRYPT : \(finalParams)")
            for (key, value) in finalParams {
                print("\(key) :: \(value)")
                multiPartData.append(((value as? String)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!)!, withName: key)
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, with: inputRequest) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseData(completionHandler: { (response) in
                    let request = response.request
                    let resp = response.response
                    let result = response.result
                    let responseString = String(data: response.data!, encoding: .utf8)
                    let error = result.error as NSError?
                    Debug.printRequest(request, response: resp, responseString: responseString, error: error)
                    GlobalUtility.hideHud()
                    
                    let finalResponseData: Data? = response.data
//                    if let data = response.data, AppConstants.enableEncryption {
//                        let strResult = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
//                        //                        let decryptedJson = AESCrypt.decrypt(strResult, password: AppConstants.aesEncryptionKey, isPreviewApp: false)
//                        //                        print(decryptedJson ?? "ERROR")
//                        //                        if let decryptedData = decryptedJson?.data(using: String.Encoding.utf8) {
//                        //                            finalResponseData = decryptedData
//                        //                        }
//                    }
                    if let data = finalResponseData {
                        
                        #if canImport(HBLogger)
                        HBLogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? 200, responseBody: responseString, requestDate: aRequestDate, responseDate: Date())
                        #endif
                        
                        do {
                            let decoder = JSONDecoder()
                            //                            decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                            let decodedValue = try decoder.decode(WSResponse<Model>.self, from: data)
                            
                            // Logout user automatically if He/She has activated session on another device
                            if decodedValue.setting?.success == "-3" {
                                GlobalUtility.hideHud()
                                // redirect to login screen if necessary
                            }
                            
                            if decodedValue.setting?.success == "401" {
                                GlobalUtility.hideHud()
                                UserDefaultsManager.logoutUser()
                                GlobalUtility.redirectToLogin()
                                
                                // redirect to login screen if necessary
                            }
                            
                            /*if decodedValue.setting?.isValidToken ?? false {
                             completionHandler(decodedValue, nil)
                             } else {
                             // create token again
                             GlobelAPI.createTokenWebserviceRequest(completed: { (success, error) in
                             if success {
                             self.dataRequest(with: inputRequest, completionHandler: completionHandler)
                             } else {
                             completionHandler(nil, error)
                             }
                             })
                             }*/
                            completionHandler(decodedValue, nil)
                        } catch let parsingError {
                            completionHandler(nil, .parsingError(error: parsingError))
                        }
                    } else {
                        completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkTimeOutError))
                    }
                })
            case .failure(let error):
                if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNetworkConnectionLost {
                    print("Time Out/Connection Lost Error")
                    //self.dataRequest(with: inputRequest, completionHandler: completionHandler)
                    completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkTimeOutError))
                } else {
                    completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
                }
            }
        }
    }
    
    static func generalSettingRequest<Model: WSResponseData>(with inputRequest: RouterProtocol, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void) {
        
        print("ROUTER BASE", inputRequest.baseUrlString)
        print("ROUTER PARAMETERS", inputRequest.parameters ?? [:])
        print("ROUTER PATH", inputRequest.path)
        print("ROUTER VERB", inputRequest.method)
        //ProgressHUD.sharedInstance.startAnimating(randomString)
        do {
            _ = try inputRequest.asURLRequest()
        } catch {
            //ProgressHUD.sharedInstance.stopAnimating(randomString)
            completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
            return
        }
        
        manager.upload(multipartFormData: { (multiPartData) in
            let reqParam = inputRequest.parameters ?? [String: Any]()
            print("PRE ENCRYPT : \(reqParam)")
            let finalParams = (inputRequest.parameters ?? [String: Any]())
            for (key, value) in finalParams {
                print("\(key) :: \(value)")
                multiPartData.append(((value as? String)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!)!, withName: key)
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, with: inputRequest) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseData(completionHandler: { (response) in
                    let request = response.request
                    let resp = response.response
                    let result = response.result
                    let responseString = String(data: response.data!, encoding: .utf8)
                    let error = result.error as NSError?
                    Debug.printRequest(request, response: resp, responseString: responseString, error: error)
                    //ProgressHUD.sharedInstance.stopAnimating(randomString)
                    
                    let finalResponseData: Data? = response.data
                    if let data = finalResponseData {
                        do {
                            let decoder = JSONDecoder()
                            //                            decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                            let decodedValue = try decoder.decode(WSResponse<Model>.self, from: data)
                            
                            completionHandler(decodedValue, nil)
                            
                            /*if decodedValue.setting?.isValidToken ?? false {
                             completionHandler(decodedValue, nil)
                             } else {
                             // create token again
                             GlobelAPI.createTokenWebserviceRequest(completed: { (success, error) in
                             if success {
                             self.dataRequest(with: inputRequest, completionHandler: completionHandler)
                             } else {
                             completionHandler(nil, error)
                             }
                             })
                             }*/
                        } catch let parsingError {
                            completionHandler(nil, .parsingError(error: parsingError))
                        }
                    } else {
                        completionHandler(nil, .other(statusCode: response.response?.statusCode, error: nil))
                    }
                })
            case .failure:
                completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
            }
        }
    }
    
    static func tokenCreationDataRequest(with request: RouterProtocol, completionHandler: @escaping (Data?, Error?) -> Void) {
        print("ROUTER BASE", request.baseUrlString)
        print("ROUTER PARAMETERS", request.parameters ?? [:])
        print("ROUTER PATH", request.path)
        print("ROUTER VERB", request.method)
        //let randomString = ""//ProgressHUD.randomString(length: 10)
        //ProgressHUD.sharedInstance.startAnimating(randomString)
        do {
            _ = try request.asURLRequest()
        } catch let requestError {
            //ProgressHUD.sharedInstance.stopAnimating(randomString)
            completionHandler(nil, requestError)
            return
        }
        Alamofire.request(request).responseData(completionHandler: { (response) in
            let request = response.request
            let resp = response.response
            let result = response.result
            let responseString = String(data: response.data!, encoding: .utf8)
            let error = result.error as NSError?
            Debug.printRequest(request, response: resp, responseString: responseString, error: error)
            //ProgressHUD.sharedInstance.stopAnimating(randomString)
            if let data = response.data, AppConstants.enableEncryption {
              //  let strResult = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
                //                let decryptedJson = AESCrypt.decrypt(strResult, password: AppConstants.aesEncryptionKey, isPreviewApp: false)
                //                print(decryptedJson ?? "ERROR")
                //                if let decryptedData = decryptedJson?.data(using: String.Encoding.utf8) {
                //                    completionHandler(decryptedData, response.result.error)
                //                } else {
                completionHandler(data, response.result.error)
                //                }
            } else {
                completionHandler(response.data, response.result.error)
            }
        })
    }
    
    
//    static func dataRequest(with inputRequest: RouterProtocol, showLoader: Bool, completionHandler: @escaping (_ dict:[Any]?, NetworkError?) -> Void) {
//        
//        print("ROUTER BASE", inputRequest.baseUrlString)
//        print("ROUTER PARAMETERS", inputRequest.parameters ?? [:])
//        print("ROUTER PATH", inputRequest.path)
//        print("ROUTER VERB", inputRequest.method)
//        print("ROUTER HEADER", inputRequest.headers ?? [:])
//        
//        if !(NetworkReachabilityManager()!.isReachable) {
//            let aVC = AppConstants.appDelegate.window?.rootViewController
//            aVC?.showTopMessage(message: AlertMessage.InternetError, type: .Error)
//            return
//        }
//        
//        if let _ = inputRequest.parameters {
//            if showLoader {
//                GlobalUtility.showHud()
//            }
//        }
//        
//        var aURL = URLComponents(string: inputRequest.baseUrlString + inputRequest.path)
//        
//        let arr = [URLQueryItem]()
////        for aObj in inputRequest.parameters!
////        {
////            arr.append(URLQueryItem(name: aObj.key, value: aObj.value as? String))
////        }
//        aURL?.queryItems = arr
//        
//        Alamofire.request(aURL!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: inputRequest.headers).responseJSON { (response) in
//            debugPrint(response)
//            debugPrint(response.result.value ?? "")
//            GlobalUtility.hideHud()
//            if let resp = (response.result.value as? [String: Any]) {
//                if let data = resp["data"] {
//                    completionHandler((data as! [String]),nil)
//                } else {
//                    completionHandler(nil,nil)
//                }
//            } else {
//                completionHandler(nil,nil)
//            }
//          //  completionHandler((response.result.value as? [String]),nil)
////            if let strDescription = NetworkService.convertToDictionary(text:response.description)
////            {
////                print(strDescription)
////            }
//            
//            if let _ = response.data {
//                
//            }
//        }
//    }
}
