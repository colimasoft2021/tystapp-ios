//
//  ChangeTaxRouter.swift
//  Tyst
//
//  Created by hb on 20/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

@objc protocol ChangeTaxRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ChangeTaxDataPassing {
    var dataStore: ChangeTaxDataStore? { get }
}

class ChangeTaxRouter: NSObject, ChangeTaxRoutingLogic, ChangeTaxDataPassing {
    weak var viewController: ChangeTaxViewController?
    var dataStore: ChangeTaxDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: ChangeTaxViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: ChangeTaxDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
