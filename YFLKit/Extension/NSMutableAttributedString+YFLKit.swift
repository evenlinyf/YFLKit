//
//  NSMutableAttributedString+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/6.
//

import UIKit
import Foundation

extension NSMutableAttributedString {
    
    @discardableResult
    public func append(_ string: String, size: CGFloat, color: UIColor) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: size)
        let textColor = color
        let attri = [NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor:textColor]
        self.append(NSAttributedString(string: string, attributes: attri))
        return self
    }
    
    @discardableResult
    public func append(_ string: String, boldSize: CGFloat, color: UIColor) -> NSMutableAttributedString {
        let font = UIFont.boldSystemFont(ofSize: boldSize)
        let textColor = color
        let attri = [NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor:textColor]
        self.append(NSAttributedString(string: string, attributes: attri))
        return self
    }
    
    @discardableResult
    public func addBreak() -> NSMutableAttributedString {
        return self.append("\n", size: 5, color: UIColor.darkGray)
    }
    
    @discardableResult
    public func setStyle(lineSpace: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString{
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        style.alignment = alignment
        self.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSMakeRange(0, self.length))
        return self
    }
    
    @discardableResult
    public func setStyle(_ style: NSParagraphStyle) -> NSMutableAttributedString {
        self.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSMakeRange(0, self.length))
        return self
    }
    
    @discardableResult
    public func setStyle(lineSpace: CGFloat, paragraphSpace: CGFloat) -> NSMutableAttributedString{
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        style.paragraphSpacing = paragraphSpace
        self.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSMakeRange(0, self.length))
        return self
    }
    
    @discardableResult
    public func setLineSpacing(_ space: CGFloat) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = space
        self.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSMakeRange(0, self.length))
        return self
    }
    
    
    ///设置后 lineSpacing 会失效， 需要一起设置
    @discardableResult
    public func setParagraphSpacing(_ space: CGFloat) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = space
        self.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSMakeRange(0, self.length))
        return self
    }
    
    @discardableResult
    public func addDeleteLine(color: UIColor = .lightGray) -> NSMutableAttributedString {
//        let style = NSUnderlineStyle(rawValue: NSUnderlineStyle.single.rawValue|NSUnderlineStyle.solid.rawValue)
        self.addAttributes([NSAttributedString.Key.strikethroughColor: color, NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue], range: NSMakeRange(0, self.length))
        return self
    }
    
}
