//
//  YFLAppStoreNavigator.swift
//  YFLKit
//
//  Created by Even Lin on 2022/8/18.
//

import Foundation
import StoreKit

class YFLAppStoreNavigator: NSObject {
    
    private(set) var appID: String?
    private var storeVC: SKStoreProductViewController?
    
    public convenience init(appID: String) {
        self.init()
        self.appID = appID
    }
    
    
    /// 跳转 App 对应的APP Store 页面
    /// - Parameter viewController: 如果传入VC， 那么为应用内跳转
    public func showAPPInAppStore(in viewController: UIViewController? = nil) {
        guard let viewController = viewController else {
            if let url = appStoreLink(), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return
        }
        
        storeVC = SKStoreProductViewController()
        storeVC?.delegate = self
        storeVC?.modalPresentationStyle = .pageSheet
        viewController.present(storeVC!, animated: true, completion: nil)
        
    }
    
    private func appStoreLink() -> URL? {
        guard let appID = appID else { return nil }
        return URL(string: "itms-apps://itunes.apple.com/cn/app/id\(appID)?mt=8")
    }
}

extension YFLAppStoreNavigator: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
