//
//  UIButton+Chainable.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit

extension YFLWrapper where Base: UIButton {
    
    @discardableResult
    public func title(_ title: String?, state: UIControl.State = .normal) -> Self {
        if let title = title {
            base.setTitle(title, for: state)
        }
        return self
    }
    
    @discardableResult
    public func font(size: CGFloat, color: UIColor?, bold: Bool = false, state: UIControl.State = .normal) -> Self {
        base.titleLabel?.font = bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        if let color = color {
            base.setTitleColor(color, for: state)
        }
        return self
    }
    
    @discardableResult
    public func image(_ image: UIImage?, state: UIControl.State = .normal) -> Self {
        guard let image = image else {
            return self
        }
        base.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor?) -> Self {
        if let color = color {
            base.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    public func frame(_ frame: CGRect?) -> Self {
        if let frame = frame {
            base.frame = frame
        }
        return self
    }
}

