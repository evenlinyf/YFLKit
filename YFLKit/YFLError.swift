//
//  YFLError.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import Foundation

public enum YFLError: Error {
    
    public enum IAPErrorReason {
        case canNotMakePayments
        case receiptURL(info: String?)
        case transaction(info: String?)
        case noProducts
        case deferred
        case failed(error: Error?)
    }
    
    case IAP(reason: IAPErrorReason)
    
}
