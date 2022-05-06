//
//  CGRect+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

extension CGRect: YFLCompatibleValue {}
extension YFLWrapper where Base == CGRect {
    
    public var centerBottom: CGPoint {
        return CGPoint(x: base.origin.x + base.width/2, y: base.origin.y + base.height)
    }
    
    public var centerTop: CGPoint {
        return CGPoint(x: base.origin.x + base.width/2, y: base.origin.y)
    }
    
    public var center: CGPoint {
        return CGPoint(x: base.origin.x + base.width/2, y: base.origin.y + base.height/2)
    }
}
