//
//  UITextField+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/16.
//

import Foundation

extension YFLWrapper where Base: UITextField {
    @discardableResult
    public func placeholder(_ placeholder: String?) -> Self {
        base.placeholder = placeholder
        return self
    }
    
    @discardableResult
    public func keyboardType(_ type: UIKeyboardType) -> Self {
        base.keyboardType = type
        return self
    }
    
    @discardableResult
    public func showClear(_ showWhileEditing: Bool) -> Self {
        base.clearButtonMode = showWhileEditing ? .whileEditing : .never
        return self
    }
    
    @discardableResult
    public func leftView(_ view: UIView?) -> Self {
        base.leftView = view
        base.leftViewMode = view != nil ? .always : .never
        return self
    }
    
    @discardableResult
    public func rightView(_ view: UIView?) -> Self {
        base.rightView = view
        base.rightViewMode = view != nil ? .always : .never
        return self
    }
    
    @discardableResult
    public func font(size: CGFloat, isBold: Bool = false) -> Self {
        base.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        base.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        base.borderStyle = style
        return self
    }
    
    
    
}
