//
//  AlertMessages.swift
//  Note
//
//  Created by hb1 on 17/10/18.
//  Copyright © 2018 Hidden Brains. All rights reserved.
//

import Foundation

/// Alert Messages to be used in whole app
struct AlertMessage {
    // General Messages
    static let yes = "Yes"
    static let no = "No"
    static let cancel = "Cancel"
    static let ok = "Ok"
    
    static let shareApp = NSLocalizedString("Try \(AppInfo.kAppName) App on Appstore or Playstore:\nhttps://itunes.apple.com/us/app/apple-store/id" + AppInfo.kAppstoreID + " \nhttps://play.google.com/store/apps/details?id=\(AppInfo.kAndriodAppId)", comment: "")
    
    static let NetworkError = NSLocalizedString("Server is not responding! Please try after sometime.", comment: "")
    static let InternetError = NSLocalizedString("Please check your internet connection and try again.",comment:"")
    static let defaultError = NSLocalizedString("Something went wrong, Please try again.",comment:"")
    
    
    static let NetworkTimeOutError = NSLocalizedString("Connection Time Out or Lost.\nPlease try again.", comment: "")
    static let otpSend = NSLocalizedString("OTP Send successfully", comment: "")
    static let success = NSLocalizedString("Success", comment: "")
    static let invalidProjectIdentifer = NSLocalizedString("Invalid Project Identifier Format", comment: "")
    
    // Camera and PhotoLibrary Access
    static let cameraAccess  = "To capture photos, allow \(AppInfo.kAppName) to access camera. Please allow it from settings."
    static let photoLibraryAccess  = "To pick photos, allow \(AppInfo.kAppName) to access photo library. Please allow it from settings."
    
    // Login Messages
    
    static let loginTitle = NSLocalizedString("Login", comment: "")
    static let requireEmail = NSLocalizedString("Please enter email", comment: "")
    static let invalidEmail = NSLocalizedString("Please enter valid email", comment: "")
    static let requireMobile = NSLocalizedString("Please enter phone number", comment: "")
    static let invalidMobile = NSLocalizedString("Please enter valid phone number", comment: "")
    static let requireUserId = NSLocalizedString("Please enter user id", comment: "")
    static let invalidUserId = NSLocalizedString("Please enter valid user id", comment: "")
    static let requirePassword = NSLocalizedString("Please enter password", comment: "")
    static let requireConfirmPassword = NSLocalizedString("Please enter confirm password", comment: "")
    
    
    // Signup Messages
    static let requirefirstName = NSLocalizedString("Please enter first name", comment: "")
    static let requirelastName = NSLocalizedString("Please enter last name", comment: "")
    static let signUpTitle = NSLocalizedString("Create an Account", comment: "")
    static let invalidPassword = NSLocalizedString("Password length must be between 6 and 15 characters and contain at least one number, one capital letter, one small letter", comment: "")
    static let enterUserName = NSLocalizedString("Please enter user name", comment: "")
    static let minValueUserName = NSLocalizedString("Username must contain more than 5 characters", comment: "")
    static let maxValueUserName = NSLocalizedString("Username shoudn't conain more than 20 characters", comment: "")
    static let invalidUserName = NSLocalizedString("Invalid username, username should not contain whitespaces or special characters", comment: "")
    
    static let minValueZip = NSLocalizedString("Zip code must contain more than 5 characters", comment: "")
    static let maxValueZip = NSLocalizedString("Zip code shoudn't conain more than 10 characters", comment: "")
    static let invalidZip = NSLocalizedString("Invalid Zip code, zip code should not contain whitespaces, numbers or special characters", comment: "")
    
    static let minValueFirstName = NSLocalizedString("Firstname must contain more than 1 character", comment: "")
    static let maxValueFirstName = NSLocalizedString("Firstname shoudn't conain more than 80 characters", comment: "")
    static let invalidFirstName = NSLocalizedString("First name should only contain characters or white space", comment: "")
    static let minValueLastName = NSLocalizedString("Lastname must contain more than 1 character", comment: "")
    static let maxValueLastName = NSLocalizedString("Lastname shoudn't conain more than 80 characters", comment: "")
    static let invalidLastName = NSLocalizedString("Last name should only contain characters or white space", comment: "")
    static let requiredateOfBirth = NSLocalizedString("Please enter date of birth", comment: "")
    static let passwordConfirmPassword = NSLocalizedString("Password and confirm password must be same", comment: "")
    static let requireStore = NSLocalizedString("Please enter store name", comment: "")
    static let requirestreetAddress = NSLocalizedString("Please select address", comment: "")
    static let requirecity = NSLocalizedString("Please enter city", comment: "")
    static let requirestate = NSLocalizedString("Please enter state", comment: "")
    static let requirezip = NSLocalizedString("Please enter zip code", comment: "")
    static let acceptTermsCondition = NSLocalizedString("You agree to the \(AppConstants.appName) Terms & Conditions and Privacy Policy", comment: "")
    static let addProfile = NSLocalizedString("Please add profile picture", comment: "")
    static let backToView = NSLocalizedString("Are you sure you want to discard this registration?", comment: "")
    
    // ForgotPassword
    static let ForgotPasswordTitle = NSLocalizedString("Forgot Password", comment: "")

    //OTPVerification
    static let otpVerificationPasswordtitle = NSLocalizedString("Verification Code", comment: "")
    static let optNotMatch = NSLocalizedString("Please enter valid otp", comment: "")
    static let verificationNumber = NSLocalizedString("Please type the verification code sent to \n+1 ", comment: "")
    static let timeOut = NSLocalizedString("Time out send again otp", comment: "")
    
    //ResetPassword
    static let resetPasswordTitle = NSLocalizedString("Reset Password", comment: "")
    
    //Setting
    static let SettingTitle = NSLocalizedString("Settings", comment: "")
    static let logOutAlert = "Are you sure you want to logout?"
    static let deleteAccountAlert = "Are you sure you want to delete account?"
    
    //MYProfile
    static let myProfileTitle = NSLocalizedString("My Profile", comment: "")
    static let receiptsTitle = NSLocalizedString("Add Receipt", comment: "")
    static let exportTitle = NSLocalizedString("Export Data", comment: "")
    
    // Change Password
    static let changePasswordTitle = NSLocalizedString("Change Password", comment: "")
    static let requireOldPassword = NSLocalizedString("Please enter old password", comment: "")
    static let requireNewPassword = NSLocalizedString("Please enter new password", comment: "")
    static let invalidNewPassword = NSLocalizedString("New password length must be between 6 and 15 characters and contain at least one number, one capital letter, one small letter", comment: "")
    static let newConfirmPassword = NSLocalizedString("New password and confirm password must be same", comment: "")
    
    //EditProfile
    static let editProfileTitle = NSLocalizedString("Edit Profile", comment: "")
    
    
    //Sendfeeedback
    static let sendFeedbackTitle = NSLocalizedString("Send Feedback", comment: "")
    static let sendFeedbackText = NSLocalizedString("You can send us your feedback about \(AppInfo.kAppName) application. We would love to here suggestions from you.", comment: "")
    static let deleteMessage = NSLocalizedString("Are you sure you want to remove this image?", comment: "")
    static let enterFeedback = NSLocalizedString("Please enter brief explanation ", comment: "")
    
    
    static let changePhoneTitle = NSLocalizedString("Change Phone Number", comment: "")
    
    // Go Add Free
    static let purchaseItem = "Please purchase the item as it cannot be restored. Do you want to purchase this subscription?"
    static let purchaseFail = "Something went wrong with your purchase, Please try again."
    static let subscriptionSuccess = "You have subscribed successfully."
    static let restoreFail = "Please purchase the item as it cannot be restored. Do you want to purchase this subscription?"
    static let purchaseAlert = "Do you want to purchase monthly subscription & Go Ad Free to remove ads and add bank account in the app? Tap on Buy. If you've already purchased then tap on Restore option."
    
    //Splash
    static let notNow = NSLocalizedString("Not Now", comment: "")
    static let update = NSLocalizedString("Update", comment: "")
    
    
    //Remove Account
    static let removeAccount = NSLocalizedString("Are you sure you want to remove this account?", comment: "")
    
    //Add Receipt
    
    static let category = NSLocalizedString("Please select category", comment: "")
    static let date = NSLocalizedString("Please select date of transaction", comment: "")
    static let amount = NSLocalizedString("Please enter transaction amount", comment: "")
    static let taxamount = NSLocalizedString("Please enter tax amount", comment: "")
    static let receiptImage = NSLocalizedString("Please upload receipt photo", comment: "")
    static let taxGreaterAmount = NSLocalizedString("Tax amount should not equal or greater that total amount", comment: "")
    
    //HOME
    static let selectStartDate = NSLocalizedString("Please select start date and end date", comment: "")
    static let selectEndDate = NSLocalizedString("Please select start date and end date", comment: "")
    
    //AddTip
    static let tipAmount = NSLocalizedString("Please enter tip amount", comment: "")
    static let tipAmountLess = NSLocalizedString("Tip amount should be less than pre-total amount", comment: "")
    
     static let taxAmountCheck = NSLocalizedString("Please enter tax amount", comment: "")
    static let taxAmountLess = NSLocalizedString("Tax amount should be less than pre-total amount", comment: "")
    static let selectReason = NSLocalizedString("Please select reason for change tax", comment: "")
    
    static let deleteTrans = NSLocalizedString("Are you sure you want to delete this transaction?", comment: "")
    
    static let pretotalNotZero = NSLocalizedString("Pre-Total cannot be zero", comment: "")
    
    //Subscription
    static let SubscriptionTitle = NSLocalizedString("Become Premium User", comment: "")
    
    //
    
    static let jailBroken = NSLocalizedString("Your device has jail broken, you can not use application", comment: "")
    
}

