//
//  UIView+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

extension UIView {
    
    public var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    public var right:CGFloat {
        get {
            return self.left + self.width
        }
    }
    
    public var bottom:CGFloat {
        get {
            return self.top + self.height
        }
    }
    
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
}


extension YFLWrapper where Base: UIView {
    
    public func removeAllSubviews() {
        while base.subviews.count > 0 {
            base.subviews.last?.removeFromSuperview()
        }
    }
    
    public func removeSubview(tag: Int) {
        for sub in base.subviews {
            if sub.tag == tag {
                sub.removeFromSuperview()
                return
            }
        }
    }
    
    //MARK: Border
    public func setCornerRadius(_ radius: CGFloat, masksToBounds: Bool = true) {
        base.layer.cornerRadius = radius
        base.layer.masksToBounds = masksToBounds
    }
    
    public func setBorder(color: UIColor, radius: CGFloat, width: CGFloat = 1, masksToBounds: Bool = true) {
        self.setCornerRadius(radius, masksToBounds: masksToBounds)
        base.layer.borderColor = color.cgColor
        base.layer.borderWidth = width
    }
    
    //MARK: Round
    public func makeRoundCorner(_ cornerRadius:CGFloat) {
        self.makeRoundFor(UIRectCorner.allCorners, radius: cornerRadius)
    }
    
    public func makeRoundBorder(_ cornerRadius: CGFloat, color: UIColor) {
        self.makeRoundFor(UIRectCorner.allCorners, radius: cornerRadius, color: color)
    }
    
    public func makeRoundFor(_ corner: UIRectCorner, radius:CGFloat) {
        self.makeRoundFor(corner, radius: radius, color: nil)
    }
    
    public func makeRoundFor(_ corner: UIRectCorner, radius: CGFloat, color: UIColor?) {
        let maskPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = base.bounds
        maskLayer.path = maskPath.cgPath
        base.layer.mask = maskLayer
        
        if let color = color {
            let borderLayer = CAShapeLayer()
            borderLayer.fillColor = nil
            borderLayer.frame = base.bounds
            borderLayer.strokeColor = color.cgColor
            borderLayer.lineWidth = 1
            borderLayer.path = maskPath.cgPath
            base.layer.addSublayer(borderLayer)
        }
    }
    
    public func makeGradient(from startColor: UIColor, to endColor: UIColor) {
        base.layer.sublayers?.removeAll(where: { (layer) -> Bool in
            return layer.isKind(of: CAGradientLayer.self)
        })
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.frame = base.bounds
        base.layer.insertSublayer(gradient, at: 0)
    }
    
    public func makeVerticalGradient(from startColor: UIColor, to endColor: UIColor) {
        base.layer.sublayers?.removeAll(where: { (layer) -> Bool in
            return layer.isKind(of: CAGradientLayer.self)
        })
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = base.bounds
        base.layer.insertSublayer(gradient, at: 0)
    }
    
    public func removeShadow() {
        base.layer.shadowOffset = CGSize.zero
        base.layer.shadowOpacity = 0
        base.layer.shadowColor = UIColor.clear.cgColor
        base.layer.shadowRadius = 0
    }
    
    public func setShadow(_ radius: CGFloat = 5, color: UIColor) {
        base.layer.shadowOffset = CGSize(width: 0, height: 6)
        base.layer.shadowOpacity = 0.4
        base.layer.shadowColor = color.cgColor
        base.layer.shadowRadius = radius
    }
    
    
    /// 设置在Autolayout中是否可压缩
    /// - Parameters:
    ///   - isCompressible: 是否可压缩
    ///   - axis: 方向 Axis
    public func setCompressible(_ isCompressible: Bool, for axis: NSLayoutConstraint.Axis) {
        base.setContentCompressionResistancePriority(UILayoutPriority(rawValue: isCompressible ? 1 : 1000), for: axis)
    }
    
    /** 各个 UILayoutPriority 的 rawValue
     
     - UILayoutPriority.required = 1000.0
     - UILayoutPriority.defaultHigh = 750.0
     - UILayoutPriority.dragThatCanResizeScene = 510.0
     - UILayoutPriority.sceneSizeStayPut = 500.0
     - UILayoutPriority.dragThatCannotResizeScene = 490.0
     - UILayoutPriority.defaultLow = 250.0
     - UILayoutPriority.fittingSizeLevel = 50.0
     **/
    
    /// 设置在Autolayout中是否可拉伸
    /// - Parameters:
    ///   - isStretchable: 是否可拉伸
    ///   - axis: 方向 Axis
    public func setStretchable(_ isStretchable: Bool, for axis: NSLayoutConstraint.Axis) {
        base.setContentHuggingPriority(UILayoutPriority(rawValue: isStretchable ? 1 : 1000), for: axis)
    }
    
    @discardableResult
    public func frame(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat, height: CGFloat) -> Self {
        base.frame = CGRect(x: x, y: y, width: width, height: height)
        return self
    }
    
    @discardableResult
    public func frame(_ frame: CGRect) -> Self {
        base.frame = frame
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor?) -> Self {
        base.backgroundColor = color
        return self
    }
    
}
