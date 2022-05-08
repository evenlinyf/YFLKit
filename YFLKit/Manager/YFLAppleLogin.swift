//
//  YFLAppleLogin.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import UIKit
import AuthenticationServices

@available(iOS 13.0, *)
public class YFLAppleLogin: NSObject {
    
    public typealias SignInWithAppleSuccessBlock = (_ userId: String, _ token: String) -> Void
    
    private var viewController: UIViewController!
    private var signInWithAppleController: ASAuthorizationController!
    
    private var success: SignInWithAppleSuccessBlock?
    private var fail: YFLComplete.V?
    
    public func signInWithApple(in viewController: UIViewController, success: SignInWithAppleSuccessBlock?, failed: YFLComplete.V?) {
        self.viewController = viewController
        self.success = success
        self.fail = failed

        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.email]//.fullName,
        
        signInWithAppleController = ASAuthorizationController.init(authorizationRequests: [request])
        signInWithAppleController.delegate = self
        signInWithAppleController.presentationContextProvider = self
        signInWithAppleController.performRequests()
    }
}

@available(iOS 13.0, *)
extension YFLAppleLogin: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userId = appleIDCredential.user
            let _ = appleIDCredential.email
            if let token = appleIDCredential.identityToken {
                let tokenString: String = NSString(data: token, encoding: String.Encoding.utf8.rawValue)! as String
                self.success?(userId, tokenString)
            }
        default:
            self.fail?()
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.fail?()
        YFLog(error.localizedDescription)
    }
}


@available(iOS 13.0, *)
extension YFLAppleLogin: ASAuthorizationControllerPresentationContextProviding {
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.viewController.view.window!
    }
}

@available(iOS 13.0, *)
extension YFLAppleLogin {
    public static func appleLoginButton(type: ASAuthorizationAppleIDButton.ButtonType, style: ASAuthorizationAppleIDButton.Style) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
        return button
    }
}

