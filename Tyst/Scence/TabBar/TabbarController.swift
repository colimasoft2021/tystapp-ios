//
//  TabBarViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    
    var lastIndex = 0
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        self.delegate = weakSelf
    }
    
    // MARK: Class Instance
    class func instance() -> TabbarController? {
        return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? TabbarController
    }
}

extension TabbarController : UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (tabBar.items)![2] {
            lastIndex = 2
            let VC1 = StoryBoard.Receipts.board.instantiateViewController(withIdentifier: AppClass.ReceiptVC.rawValue) as? ReceiptsViewController
            let navController = NavController(rootViewController: VC1!)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated:true, completion: nil)
        }else {
            lastIndex = 0
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if lastIndex == 2 {
            return false
        }else {
            lastIndex = tabBarController.selectedIndex
        }
        return true
    }
    
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if AppConstants.isLoginSkipped {
//            var displayVC : UIViewController?
//            if let aNavVC = viewController as? NavController {
//                displayVC = aNavVC.topViewController
//            } else {
//                displayVC = viewController
//            }
//            if displayVC is ReceiptsViewController {
//                GlobalUtility.redirectToLogin()
//                return false
//            }
//            if displayVC is ExportViewController {
//                GlobalUtility.redirectToLogin()
//                return false
//            }
//            if displayVC is MyProfileViewController {
//                GlobalUtility.redirectToLogin()
//                return false
//            }
//        }
//
//        return true
//    }
}
