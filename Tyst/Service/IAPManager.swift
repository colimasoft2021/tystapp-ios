//
//  IAPManager.swift
//  Tyst
//
//  Created by hb on 28/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import StoreKit

enum PKIAPHandlerAlertType {
    case setProductIds
    case disabled
    case restored
    case purchased
    
    var message: String{
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}
class IAPManager: NSObject {
    
    static let shared = IAPManager()
    private override init() { }
    
    fileprivate var productIds = [String]()
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductCompletion: (([SKProduct])->Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductCompletion: ((PKIAPHandlerAlertType, SKProduct?, Data?)->Void)?
    
    var isLogEnabled: Bool = true
    
    //MARK:- Methods
    
    //Set Product Ids
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }
    
    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchase(product: SKProduct, completion: @escaping ((PKIAPHandlerAlertType, SKProduct?, Data?)->Void)) {
        self.purchaseProductCompletion = completion
        self.productToPurchase = product
        
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        }
        else {
            completion(PKIAPHandlerAlertType.disabled, nil, nil)
        }
    }
    
    // RESTORE PURCHASE
    func restorePurchase(){
        GlobalUtility.showHud()
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){
        self.fetchProductCompletion = complition
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(PKIAPHandlerAlertType.setProductIds.message)
            fatalError(PKIAPHandlerAlertType.setProductIds.message)
        }
        else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
extension IAPManager: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        GlobalUtility.hideHud()
        if (response.products.count > 0) {
            if let completion = self.fetchProductCompletion {
                completion(response.products)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let completion = self.purchaseProductCompletion {
            completion(PKIAPHandlerAlertType.restored, nil, nil)
        }
        GlobalUtility.hideHud()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        log("Restore failed \(error)")
        if error._code == SKError.paymentCancelled.rawValue{
            print("Cancelled")
        }else if error._code == SKError.unknown.rawValue{
            if UIDevice.version() < 12{
                print("Cancelled")
            }else{
                GlobalUtility.getRootViewController().showTopMessage(message: "AlertMessage.subscription_failed", type: .Error)
            }
        }else{
            GlobalUtility.getRootViewController().showTopMessage(message: "AlertMessage.restore_failed", type: .Error)
        }
        
        GlobalUtility.hideHud()
    }
    
    
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    GlobalUtility.hideHud()
                    log("Product purchase done")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let completion = self.purchaseProductCompletion {
                        if let receiptData = NSData(contentsOf: Bundle.main.appStoreReceiptURL!) {
                            completion(PKIAPHandlerAlertType.purchased, self.productToPurchase, receiptData as Data)
                        }
                    }
                    break
                    
                case .failed:
                    GlobalUtility.hideHud()
                    log("Product purchase failed \((trans.error?.localizedDescription)!)")
                    
                    if trans.error!._code == SKError.paymentCancelled.rawValue {
                        print("Cancelled")
                    }else if trans.error!._code == SKError.unknown.rawValue{
                        if UIDevice.version() < 12{
                            print("Cancelled")
                        }else{
                            GlobalUtility.getRootViewController().showTopMessage(message: "AlertMessage.subscription_failed", type: .Error)
                        }
                    }else{
                        GlobalUtility.getRootViewController().showTopMessage(message: "AlertMessage.subscription_failed", type: .Error)
                    }
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .restored:
                    GlobalUtility.hideHud()
                    log("Product restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let completion = self.purchaseProductCompletion {
                        if let receiptData = NSData(contentsOf: Bundle.main.appStoreReceiptURL!) {
                            GlobalUtility.getRootViewController().showTopMessage(message: "AlertMessage.restore_success", type: .Success)
                            completion(PKIAPHandlerAlertType.restored, self.productToPurchase, receiptData as Data)
                        }
                    }
                    break
                    
                default: break
                }
            }
        }
        
    }
}

