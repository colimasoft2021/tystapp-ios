# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Tyst' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tyst

    # Swift Lint : https://github.com/realm/SwiftLint
    pod 'SwiftLint'
    
    # Fabric & Crashlytics
    pod 'Firebase/Crashlytics'
    
    # Network
    pod 'Alamofire', '~> 4.9.1'
    
    # Keyboard Helper
    pod 'IQKeyboardManagerSwift'
    
    # Image Downlaod and Caching
    pod 'Kingfisher'
    
    # Lottie Animation (Loader)
    pod 'lottie-ios'
    
    # Snackbar to show success or fail Messages
    pod 'SwiftMessages'
    
    # Application Rating
    pod 'AppRating', '>= 0.0.1'
    
    # Image Helper
    pod 'SKPhotoBrowser', '~> 6.0.0'
    
    # OTP
    pod 'SVPinView', '~> 1.0'
    
    # Google sign in
    pod 'GoogleSignIn', '>= 6.0.0'
    
    # Facebook sign in
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'FBAudienceNetwork'
    
    # Google places search
    pod 'GooglePlaces'
    
    # Google Analytics
    pod 'Firebase/Analytics'
    
    # Google Ads
    pod 'Google-Mobile-Ads-SDK'
    
    # For in app Purchase
    pod 'SwiftyStoreKit', '~> 0.14.2'
    
    # Refresh table view, collection view, scroll view
    pod 'CRRefresh'
    
    # Letters create from name
    pod 'InitialsImageView'
    
    # Plade api response
    pod 'Plaid', '>= 3.0.0'
    
    pod 'FSCalendar'
    pod 'FittedSheets'
    pod 'DWAnimatedLabel', '~> 1.1'
    
    # Setting Pod Swift Version
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        if ['IQKeyboardManagerSwift', 'Kingfisher', 'lottie-ios', 'SwiftMessages', 'Alamofire', 'GoogleSignIn', 'FBSDKLoginKit', 'FBSDKCoreKit','InitialsImageView'].include? target.name
          target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
          end
        end
      end
    end
  end