//
//  UILabel+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit

extension YFLWrapper where Base: UILabel {
    
    @discardableResult
    public func title(_ title: String) -> Self {
        base.text = title
        return self
    }
    
    @discardableResult
    public func font(size: CGFloat, isBold: Bool = false) -> Self {
        base.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        return self
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> Self {
        base.textColor = color
        return self
    }
    
}


