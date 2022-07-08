//
//  ExpenseListPopUpViewController.swift
//  Tyst
//
//  Created by hb on 06/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class ExpenseListPopUpViewController: UIViewController {
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Class Instance
    class func instance() -> ExpenseListPopUpViewController? {
        return UIStoryboard(name: "ExpenseListPopUp", bundle: nil).instantiateViewController(withIdentifier: "ExpenseListPopUpViewController") as? ExpenseListPopUpViewController
    }
    
    //MARK: IBAction
    @IBAction func btnOkAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
