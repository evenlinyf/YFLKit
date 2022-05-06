//
//  UIApplication+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

extension UIApplication: YFLCompatible {}

extension YFLWrapper where Base == UIApplication {
    public var window: UIWindow? {
        return base.keyWindow
    }
    
    public var rootVC: UIViewController? {
        return base.keyWindow?.rootViewController
    }
}
