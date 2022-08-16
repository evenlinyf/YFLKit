//
//  UIButton+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit

extension YFLWrapper where Base: UIButton {
    
    @discardableResult
    public func title(_ title: String?, for state: UIControl.State = .normal) -> Self {
        if let title = title {
            base.setTitle(title, for: state)
        }
        return self
    }
    
    @discardableResult
    public func font(size: CGFloat, isBold: Bool = false) -> Self {
        base.titleLabel?.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        return self
    }
    
    @discardableResult
    public func color(_ color: UIColor?, for state: UIControl.State = .normal) -> Self {
        if let color = color {
            base.setTitleColor(color, for: state)
        }
        return self
    }
    
    @discardableResult
    public func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        guard let image = image else {
            return self
        }
        base.setImage(image, for: state)
        return self
    }
    
}

