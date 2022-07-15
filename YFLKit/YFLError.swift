//
//  YFLError.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import Foundation
import StoreKit

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

extension YFLError.IAPErrorReason {
    
    public var errorMessage: String {
        switch self {
        case .canNotMakePayments: return "Can not make payments"
        case .receiptURL(info: let info): return info ?? "receiptURL error"
        case .transaction(info: let info): return info ?? "transaction error"
        case .noProducts: return "no in app purchase products found in SKProductsResponse"
        case .deferred: return "transactionState is deferred"
        case .failed(error: let error):
            guard let iapError = error as? NSError, iapError.domain == SKErrorDomain else {
                return error?.localizedDescription ?? "unknown error"
            }
            switch iapError.code {
            case SKError.unknown.rawValue: return "client is not allowed to issue the request, etc."
            case SKError.clientInvalid.rawValue: return "client is not allowed to issue the request, etc."
            case SKError.paymentCancelled.rawValue: return "user cancelled the request, etc."
            case SKError.paymentInvalid.rawValue: return "purchase identifier was invalid, etc."
            case SKError.paymentNotAllowed.rawValue: return "this device is not allowed to make the payment"
            case SKError.storeProductNotAvailable.rawValue: return "Product is not available in the current storefront"
            case SKError.cloudServicePermissionDenied.rawValue: return "user has not allowed access to cloud service information"
            case SKError.cloudServiceNetworkConnectionFailed.rawValue: return "the device could not connect to the nework"
            case SKError.cloudServiceRevoked.rawValue: return "user has revoked permission to use this cloud service"
            default:
                if #available(iOS 12.2, *) {
                    switch iapError.code {
                    case SKError.privacyAcknowledgementRequired.rawValue: return "The user needs to acknowledge Apple's privacy policy"
                    case SKError.unauthorizedRequestData.rawValue: return "The app is attempting to use SKPayment's requestData property, but does not have the appropriate entitlement"
                    case SKError.invalidOfferIdentifier.rawValue: return "The specified subscription offer identifier is not valid"
                    case SKError.invalidSignature.rawValue: return "The cryptographic signature provided is not valid"
                    case SKError.missingOfferParams.rawValue: return "One or more parameters from SKPaymentDiscount is missing"
                    case SKError.invalidOfferPrice.rawValue: return "The price of the selected offer is not valid (e.g. lower than the current base subscription price)"
                    case SKError.overlayCancelled.rawValue: return "overlayCancelled"
                    default:
                        if #available(iOS 14.0, *) {
                            switch iapError.code {
                            case SKError.overlayInvalidConfiguration.rawValue: return "overlayInvalidConfiguration"
                            case SKError.overlayTimeout.rawValue: return "overlayTimeout"
                            case SKError.ineligibleForOffer.rawValue: return "User is not eligible for the subscription offer"
                            case SKError.unsupportedPlatform.rawValue: return "unsupportedPlatform"
                            default:
                                if #available(iOS 14.5, *) {
                                    switch iapError.code {
                                    case SKError.overlayPresentedInBackgroundScene.rawValue: return "Client tried to present an SKOverlay in UIWindowScene not in the foreground"
                                    default:
                                        return iapError.localizedDescription
                                    }
                                }
                            }
                        }
                    }
                }
                return iapError.localizedDescription
            }
        }
    }
}
