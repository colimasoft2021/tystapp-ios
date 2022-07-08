//
//  BankTransactionRouter.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

@objc protocol BankTransactionRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol BankTransactionDataPassing {
    var dataStore: BankTransactionDataStore? { get }
}

class BankTransactionRouter: NSObject, BankTransactionRoutingLogic, BankTransactionDataPassing {
    weak var viewController: BankTransactionViewController?
    var dataStore: BankTransactionDataStore?
    
}
