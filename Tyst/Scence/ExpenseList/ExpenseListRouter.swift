//
//  ExpenseListRouter.swift
//  Tyst
//
//  Created by hb on 19/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

@objc protocol ExpenseListRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ExpenseListDataPassing {
    var dataStore: ExpenseListDataStore? { get }
}

class ExpenseListRouter: NSObject, ExpenseListRoutingLogic, ExpenseListDataPassing {
    weak var viewController: ExpenseListViewController?
    var dataStore: ExpenseListDataStore?
    
    
}
