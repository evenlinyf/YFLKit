//
//  UIEdgeInsets+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

extension UIEdgeInsets {
    
    public static func all(_ margin: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    public static func left(_ margin: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
    }
    
    public static func top(_ margin: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: 0, bottom: 0, right: 0)
    }
    
    public static func bottom(_ margin: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
    }
    
    public static func right(_ margin: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: margin)
    }
    
    public static func horizontal(_ margin: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
    
    public static func vertical(_ margin: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
    }
    
    public init(h: CGFloat, v: CGFloat) {
        self.init(top: v, left: h, bottom: v, right: h)
    }
}
