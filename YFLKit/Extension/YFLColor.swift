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
        let fSize = CGSize(width: size.width > 0 ? size.width : 20, height: size.height > 0 ? size.height : 20)
        UIGraphicsBeginImageContext(fSize);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(base.cgColor)
        context?.fill(CGRect(origin: .zero, size: fSize))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
}


extension UIColor {
    
    public convenience init(hex: UInt64) {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b: CGFloat = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    public convenience init(hex:UInt64, alpha:CGFloat) {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b: CGFloat = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red:r,green: g, blue:b, alpha:alpha)
    }
}

extension String {
    
    public var color: UIColor {
        guard let hex = self.hexValue else {
            if let colorSet = UIColor(named: self) {
                return colorSet
            } else {
                return .red
            }
        }
        return UIColor(hex: hex)
    }
    
    public func color(_ alpha: CGFloat) -> UIColor {
        guard let hex = self.hexValue else { return .red }
        return UIColor(hex: hex, alpha: alpha)
    }
    
    public var hexValue: UInt64? {
        var hexString = self
        if hasPrefix("#") {
            hexString = hexString.replacingOccurrences(of: "#", with: "")
        }
        if hasPrefix("0x") {
            hexString = hexString.replacingOccurrences(of: "0x", with: "")
        }
        guard hexString.count == 6 else {
            YFLog("It seems the hex value is illegal, 貌似这个值不太对啊")
            return nil
        }
        
        let scanner = Scanner(string: hexString)
        var colorValue: UInt64 = 0
        scanner.scanHexInt64(&colorValue)
        return colorValue
    }
}
