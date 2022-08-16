//
//  CGRect+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation


extension CGRect {
    public var centerBottom: CGPoint {
        return CGPoint(x: self.origin.x + self.width/2, y: self.origin.y + self.height)
    }
    
    public var centerTop: CGPoint {
        return CGPoint(x: self.origin.x + self.width/2, y: self.origin.y)
    }
    
    public var center: CGPoint {
        return CGPoint(x: self.origin.x + self.width/2, y: self.origin.y + self.height/2)
    }
}

extension CGRect: YFLCompatibleValue {}
extension YFLWrapper where Base == CGRect {
    
    @available(*, deprecated, renamed: "self.centerBottom", message: "Use self.centeBottom is more convenient")
    public var centerBottom: CGPoint {
        return CGPoint(x: base.origin.x + base.width/2, y: base.origin.y + base.height)
    }
    
    @available(*, deprecated, renamed: "self.centerTop", message: "Use self.centerTop is more convenient")
    public var centerTop: CGPoint {
        return CGPoint(x: base.origin.x + base.width/2, y: base.origin.y)
    }
    
    @available(*, deprecated, renamed: "self.center", message: "Use self.center is more convenient")
    public var center: CGPoint {
        return CGPoint(x: base.origin.x + base.width/2, y: base.origin.y + base.height/2)
    }
}
