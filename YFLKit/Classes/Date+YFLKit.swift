//
//  Date+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

extension Date: YFLCompatibleValue {}

extension YFLWrapper where Base == Date {
    public var year: Int? {
        return Calendar.current.dateComponents([.year], from: base).year
    }
    
    public var month: Int? {
        return Calendar.current.dateComponents([.month], from: base).month
    }
    
    public var day: Int? {
        return Calendar.current.dateComponents([.day], from: base).day
    }
    
    /// TimeIntervalSince1970
    public var timeStamp: String {
        let timeInterval: TimeInterval = base.timeIntervalSince1970
        let time = Int(timeInterval)
        return "\(time)"
    }
    
    /// 毫秒时间戳
    public var msecTimeStamp: String {
        let timeInterval: TimeInterval = base.timeIntervalSince1970
        let milliSec = CLongLong(round(timeInterval * 1000))
        return "\(milliSec)"
    }
    
    public func timeString(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale.system
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter.string(from: base)
    }
}
