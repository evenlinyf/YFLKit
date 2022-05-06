//
//  String+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import Foundation
import UIKit
import CommonCrypto

extension String: YFLCompatibleValue {}

extension YFLWrapper where Base == String {
    
    public func securedName(_ showCount: Int = 1) -> String {
        if base.count > showCount {
            return "\(base.prefix(showCount))**"
        }
        return "\(base)**"
    }
    
    public func size(with font: UIFont) -> CGSize {
        return base.size(withAttributes: [NSAttributedString.Key.font : font])
    }
    
    public func urlEncoded() -> String {
        let encodeUrlString = base.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    public func jsonObj() throws -> Any {
        let jsonData: Data = base.data(using: .utf8)!
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
    
    public var md5: String {
        let utf8 = base.cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") {$0 + String(format: "%02X", $1)}
    }
    
    public func removeSpace() -> String {
        return base.replacingOccurrences(of: " ", with: "")
    }
    
    public func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale.system
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter.date(from: base)
    }
    
    public func toDateString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        let date = self.toDate(format: format)
        return date?.yfl.timeString(format)
    }
    
    //MARK: validator
    
    public func isPureNumber() -> Bool {
        let scanner = Scanner(string: base)
        var number: Int = 0
        return scanner.scanInt(&number) && scanner.isAtEnd
    }
    
    public func isValidPhone() -> Bool {
        
        guard base.first == "1" else {
            return false
        }
        guard base.count == 11 else {
            return false
        }
        guard self.isPureNumber() else {
            return false
        }
        return true
    }
    
    public func isValidMoney() -> Bool {
        if base.isEmpty == true {
            return true
        }
        let expression = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: base, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (base as NSString).length))
        return numberOfMatches != 0
    }
    
    public func isValidSms() -> Bool {
        guard base.count == 6 else {
            return false
        }
        guard self.isPureNumber() else {
            return false
        }
        return true
    }
    
}



