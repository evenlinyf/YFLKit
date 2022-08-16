//
//  YFLogger.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import Foundation

public var enableYFLog: Bool = true

public func YFLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
#if DEBUG
    guard enableYFLog else { return }
    let time = Date().yfl.timeString("yyyy-MM-dd HH:mm:ss.SSS")
    let finalString = "📔[\(time)] \((file as NSString).lastPathComponent)[\(line)].\(method)\n\(message)"
    print(finalString)
#endif
}
