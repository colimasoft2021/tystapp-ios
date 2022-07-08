//
//  BaseViewControllerWithAd.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire
import LinkKit
#if canImport(HBLogger)
import HBLogger
#endif


/// Base View controller with ads
class BaseViewControllerWithAd: UIViewController {
    /// Interstitial ads
    var interstitialView: GADInterstitial!
    /// Banner view for ads
    var bannerView: GADBannerView!
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppConstants.backgroundColor
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logScreenEvent("\(#function)")
    }
  
    func logScreenEvent(_ functionName:String) {
        var aName = GlobalUtility.classNameAsString(obj: self) + " Screen"
        aName = aName.replacingOccurrences(of: "ViewController", with: "")
        let className = GlobalUtility.classNameAsString(obj: self)

        if let aModel = UserDefaultsManager.getLoggedUserDetails()
        {
            GlobalUtility.setUser(user: aModel.userInfo![0].email ?? "")
        }
        else
        {
            GlobalUtility.setUser(user: "N/A")
        }

        GlobalUtility.logScreenEvent(file: className, name: functionName, description: aName)

    }
    
    
    /// set ad mob view
    ///
    /// - Parameter viewAdd: view for ad
    func setAddMobView(viewAdd: UIView) {
        let adSize = GADAdSizeFromCGSize(CGSize(width: viewAdd.frame.width, height: 50))
        bannerView = GADBannerView(adSize: adSize)
        addBannerViewToView(bannerView, viewAdd: viewAdd)
        bannerView.adUnitID = ADMobDetail.admodId
        bannerView.center = viewAdd.center
        bannerView.delegate = self
        bannerView.frame = viewAdd.frame
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    /// Add Banner Ad to view
    ///
    /// - Parameters:
    ///   - bannerView:Banner View
    ///   - viewAdd: View ad
    func addBannerViewToView(_ bannerView: GADBannerView, viewAdd: UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.center = viewAdd.center
        viewAdd.addSubview(bannerView)
    }
    
    /// Reload Interstitial ad
    ///
    /// - Returns: Return Interstitial ad
    func reloadInterstitialAd() -> GADInterstitial {
        interstitialView = GADInterstitial(adUnitID: ADMobDetail.adUnitID)
        interstitialView.delegate = self
        let request = GADRequest()
        interstitialView.load(request)
        return interstitialView
    }
    
    /// Show Full ad
    func showFullAdd() {
        if interstitialView != nil {
            if (interstitialView.isReady == true){
                //interstitialView.present(fromRootViewController:self)
            } else {
                print("ad wasn't ready")
                interstitialView = reloadInterstitialAd()
            }
        } else {
            print("ad wasn't ready")
            interstitialView = reloadInterstitialAd()
        }
        
        interstitialView.present(fromRootViewController:self)
    }
    
    /// Check internet is available
    ///
    /// - Returns: Return If internet is available
    func internetAvailable()-> Bool {
        if !(NetworkReachabilityManager()!.isReachable) {
            self.showTopMessage(message: AlertMessage.InternetError, type: .Error)
            return false
        }else {
            return true
        }
    }
    
}

// MARK: - Interstitial ads
extension BaseViewControllerWithAd: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("Did Dismiss Screen")
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
         print("Ad Received")
         if ad.isReady {
             interstitialView.present(fromRootViewController: self)
         }
    }
}

// MARK: - Ad Mob
extension BaseViewControllerWithAd: GADBannerViewDelegate {
    
    /// Method is called when ad is received
    ///
    /// - Parameter bannerView: Bannerview
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("")
    }
}
