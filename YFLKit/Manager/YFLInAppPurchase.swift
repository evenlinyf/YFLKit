//
//  YFLInAppPurchase.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import UIKit
import StoreKit

public enum IAPResult {
    case success(_ transaction: (productId: String, purchaseDate: String, receipt: String, transactionId: String))
    case failed(_ error: YFLError?)
    case canceled
}

public class YFLInAppPurchase: NSObject {
    public static let shared = YFLInAppPurchase()
    private var complete: ((IAPResult) -> Void)!
    private var productIdentifier: String?
    
    private override init(){
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    private func canMakePayment() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func purchaseProduct(_ productId: String, complete: @escaping (IAPResult) -> Void) {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        YFLog(receiptUrl)
        self.complete = complete
        if (self.canMakePayment()) {
            self.productIdentifier = productId
            self.makePayment(productId)
        } else {
            completeAction(.failed(.IAP(reason: .canNotMakePayments)))
        }
    }
    
    private func completeAction(_ result: IAPResult) {
        DispatchQueue.main.async {
            self.complete(result)
        }
    }
    
    private func makePayment(_ productId: String) {
        let prodSet: Set = [productId]
        let iapRequest = SKProductsRequest(productIdentifiers: prodSet)
        iapRequest.delegate = self
        iapRequest.start()
    }

    private func verifyPurchase(transaction: SKPaymentTransaction) {
        defer {
            SKPaymentQueue.default().finishTransaction(transaction)
        }
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
            completeAction(.failed(.IAP(reason: .receiptURL(info: "nil"))))
            return
        }
        var receiptData: Data?
        
        do {
            receiptData = try Data(contentsOf: receiptUrl)
        } catch let error {
            completeAction(.failed(.IAP(reason: .receiptURL(info: error.localizedDescription))))
            return
        }
        
        if let productIdentifier = productIdentifier,
           let purchaseDate = transaction.transactionDate?.yfl.timeString("yyyy-MM-dd hh:mm:ss"),
           let transactionId = transaction.transactionIdentifier {
            completeAction(.success((productIdentifier, purchaseDate, receiptData!.base64EncodedString(), transactionId)))
        } else {
            completeAction(.failed(.IAP(reason: .transaction(info: "error"))))
        }
    }
    
    private func purchaseFailed(transaction: SKPaymentTransaction) {
        defer {
            SKPaymentQueue.default().finishTransaction(transaction)
        }
        completeAction(.failed(.IAP(reason: .failed(error: transaction.error))))
    }
}

extension YFLInAppPurchase: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        guard products.count > 0 else {
            self.completeAction(.failed(.IAP(reason: .noProducts)))
            return
        }
        let product = products.first(where: { asProd in
            return asProd.productIdentifier == self.productIdentifier
        })
        
        guard let product = product else {
            self.completeAction(.failed(.IAP(reason: .noProducts)))
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        self.completeAction(.failed(.IAP(reason: .failed(error: error))))
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        
    }
    
    
}

extension YFLInAppPurchase: SKPaymentTransactionObserver {
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                verifyPurchase(transaction: transaction)
            case .restored:
                break
            case .failed:
                if let error = transaction.error as NSError? {
                    if error.domain == SKErrorDomain {
                        if error.code == SKError.paymentCancelled.rawValue {
                            completeAction(.canceled)
                            return
                        }
                    }
                }
                completeAction(.failed(.IAP(reason: .failed(error: transaction.error))))
            case .deferred:
                completeAction(.failed(.IAP(reason: .deferred)))
            default:
                completeAction(.failed(.IAP(reason: .failed(error: transaction.error))))
            }
        }
    }
    
    
}
