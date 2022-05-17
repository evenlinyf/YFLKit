//
//  NSObject+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/17.
//

import Foundation

extension NSObject {
    static var reuseIdentifier: String {
        return String(describing: classForCoder()) + "ReuseID"
    }
}
