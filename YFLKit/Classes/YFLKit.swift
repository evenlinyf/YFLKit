//
//  YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

public struct YFLWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol YFLCompatible: AnyObject {}

extension YFLCompatible {
    public var yfl: YFLWrapper<Self> {
        get { return YFLWrapper(self) }
        set {}
    }
}

public protocol YFLCompatibleValue {}

extension YFLCompatibleValue {
    public var yfl: YFLWrapper<Self> {
        get { return YFLWrapper(self) }
        set {}
    }
}

extension UIView: YFLCompatible {}
