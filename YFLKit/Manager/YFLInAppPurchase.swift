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
        YFLog("🍎 🍎 🍎 iap add observer")
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    private func canMakePayment() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func purchaseProduct(_ productId: String, complete: @escaping (IAPResult) -> Void) {
        YFLog("🍎 🍎 🍎 调用苹果内购买 productId = >>>>>>\(productId)<<<<<<")
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
        YFLog("🍎 🍎 🍎 请求对应productId的内购买产品")
        let prodSet: Set = [productId]
        let iapRequest = SKProductsRequest(productIdentifiers: prodSet)
        iapRequest.delegate = self
        iapRequest.start()
    }

    private func verifyPurchase(transaction: SKPaymentTransaction) {
        defer {
            YFLog("🍎 🍎 🍎 结束交易")
            SKPaymentQueue.default().finishTransaction(transaction)
        }
        //file:///private/var/mobile/Containers/Data/Application/F41E2C5E-4702-4F1A-8E95-5DBB744A4B30/StoreKit/sandboxReceipt
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
            YFLog("🍎 🍎 🍎 结束交易")
            SKPaymentQueue.default().finishTransaction(transaction)
        }
        completeAction(.failed(.IAP(reason: .failed(error: transaction.error))))
    }
}

extension YFLInAppPurchase: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //response 返回了设置的所有内购买项目
        YFLog("🍎 🍎 🍎  收到了IAP回调")
        let products = response.products
        guard products.count > 0 else {
            YFLog("🍎 🍎 🍎 一个商品都没有")
            self.completeAction(.failed(.IAP(reason: .noProducts)))
            return
        }
        let product = products.first(where: { asProd in
            return asProd.productIdentifier == self.productIdentifier
        })
        
        guard let product = product else {
            YFLog("🍎 🍎 🍎 找不到该productId的商品")
            self.completeAction(.failed(.IAP(reason: .noProducts)))
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        YFLog("🍎 🍎 🍎 In App Purchase request: \(request) \n🍎 🍎 🍎 failed with error: \(error.localizedDescription)")
        self.completeAction(.failed(.IAP(reason: .failed(error: error))))
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        YFLog("🍎 🍎 🍎 In App Purchase finished with request: \(request.description)")
    }
    
    
}

extension YFLInAppPurchase: SKPaymentTransactionObserver {
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        YFLog("🍎 🍎 🍎 restore ended")
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        YFLog(error.localizedDescription)
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        YFLog("🍎 🍎 🍎 removed \(transactions.count) transactions = \(transactions)")
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        YFLog("🍎 🍎 🍎 updatedTransactions count = \(transactions.count)")
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                YFLog("正在购买")
            case .purchased:
                YFLog("IAP已购买")
                verifyPurchase(transaction: transaction)
            case .restored:
                YFLog("IAP已购买， 需要恢复购买")
            case .failed:
                if let error = transaction.error as NSError? {
                    if error.domain == SKErrorDomain {
                        if error.code == SKError.paymentCancelled.rawValue {
                            completeAction(.canceled)
                            return
                        }
                    }
                }
                YFLog("IAP失败了\(String(describing: transaction.error))")
                completeAction(.failed(.IAP(reason: .failed(error: transaction.error))))
            case .deferred:
                YFLog("等待其他操作")
                completeAction(.failed(.IAP(reason: .deferred)))
            default:
                completeAction(.failed(.IAP(reason: .failed(error: transaction.error))))
                YFLog("购买失败")
            }
        }
    }
    
    
}
