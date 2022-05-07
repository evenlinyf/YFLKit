//
//  YFLogger.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import Foundation

public func YFLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
#if DEBUG
    let time = Date().yfl.timeString("yyyy-MM-dd HH:mm:ss")
    let finalString = "YFLog \(time)\n\((file as NSString).lastPathComponent)[\(line)],\(method):\n\(message)"
    print(finalString)
#endif
}
