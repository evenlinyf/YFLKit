//
//  YFColor.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit

extension UIColor: YFLCompatible {}

extension YFLWrapper where Base: UIColor {
    
    public func toImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(base.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width > 0 ? size.width : 20, height: size.height > 0 ? size.height : 20))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
}


extension UIColor {
    
    public convenience init(hex: UInt32) {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b: CGFloat = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    public convenience init(hex:UInt32, alpha:CGFloat) {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b: CGFloat = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red:r,green: g, blue:b, alpha:alpha)
    }
}
