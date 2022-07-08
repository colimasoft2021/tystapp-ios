//
//  SignUpViewControllerExtension.swift
//  WhiteLabelApp
//
//  Created by hb on 30/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleSignIn

// MARK: - TextField Delegates
extension SignUpViewController: UITextFieldDelegate {
    
    /// Method is called when textfield begins editing
    ///
    /// - Parameter textField: Textfield reference
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFieldStreet {
            if let googleApi = GoogleSearch.instance() {
                googleApi.completion = {predictor, error in
                    guard error == nil else {return}
                    self.txtFieldStreet.text = ""
                    if let predictor = predictor {
                        let placeClient = GMSPlacesClient.shared()
                        placeClient.lookUpPlaceID(predictor.placeID) { (place, error) in
                            if error == nil {
                                self.txtFieldStreet.text = ""
                                self.txtFieldState.text = ""
                                self.txtFieldCity.text = ""
                                self.txtFieldZip.text = ""
                                self.stateId = ""
                                self.latitude = String(describing: (place?.coordinate.latitude)!)
                                self.longitude = String(describing: (place?.coordinate.longitude)!)
                                self.setSearchDetailsAddress(addressComponent: (place?.addressComponents)!)
                            }
                        }
                    }
                }
                self.present(googleApi, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UIPicker View Delegates
extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    /// Returns Number of componenets in picker view
    ///
    /// - Parameter pickerView: Pickerview Reference
    /// - Returns: Number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Returns number of rows in pickerview
    ///
    /// - Parameters:
    ///   - pickerView: Pickerview reference
    ///   - component: Component in pickerview
    /// - Returns: Returns array count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.stateListData.count
    }
    
    /// Title for picker view
    ///
    /// - Parameters:
    ///   - pickerView: picker view reference
    ///   - row: Row for pickerview
    ///   - component: component
    /// - Returns: Returns string value
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateListData[row].state ?? ""
    }
}

// MARK: - API Response
extension SignUpViewController: SignUpDisplayLogic {
    // Social Signup response
    /// Did Receive Email Sign up Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSocialSignUpResponse(viewModel: Login.ViewModel?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = viewModel {
                AppConstants.isLoginSkipped = false
                UserDefaultsManager.setLoggedUserDetails(userDetail: data)
                self.showTopMessage(message: message, type: .Success)
//                if let inst = data.institution?.count, inst == 0 {
//                    pladeApiConfiguration()
//                } else {
//                    router?.redirectToHome()
//                }
                router?.redirectToHome()
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    
    /// Did Receive Add Bank Account Response
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveAddAccountResponse(response: AddBankAccount.ViewModel?, message: String, success: String) {
        if success == "1" {
            
            let user = UserDefaultsManager.getLoggedUserDetails()
            user?.institution?.append(response!)
            UserDefaultsManager.setLoggedUserDetails(userDetail: user!)
            
            GlobalUtility.showHud()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7)) {
                let req = FetchTransaction.Request(accessToken: response?.institutionId ?? "")
                self.interactor?.fetchTrnasaction(request: req)
            }

        } else {
            UserDefaultsManager.logoutUser()
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Unique user Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    
    func didReceiveEmailSignUpResponse(viewModel: Login.ViewModel?, message: String, successCode: String) {
        if successCode == "1" {
            AppConstants.isLoginSkipped = false
            self.showTopMessage(message: message, type: .Success, displayDuration:8)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    
    /// Did Receive state list Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveStateListResponse(response: [StateList.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = response {
                WhiteLabelSessionHandler.shared.setStateList(data: data)
                self.stateListData = data
            }
        }
    }
    
    /// Did Receive fetchResponse
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveFetchTransactionResponse(message: String, success: String) {
        if success == "1" {
            router?.redirectToHome()
            self.showTopMessage(message: message, type: .Success)
        } else {
            UserDefaultsManager.logoutUser()
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
