//
//  YFDevice.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

public struct YFLDevice {
    
    public static var screenSize: String {
        return "\(UIScreen.main.bounds.size.height)*\(UIScreen.main.bounds.size.width)"
    }
    
    /// Bundle Identifier
    public static var bundleId: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    /// APP Version (CFBundleShortVersionString)
    public static var appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    
    /// App Build Version (CFBundleVersion)
    public static var appBuildVersion: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    
    /// APP名称
    public static var appName: String {
        let key = "CFBundleDisplayName"
        if let lid = Bundle.main.localizedInfoDictionary {
            if let name = lid[key] as? String {
                return name
            }
        }
        if let info = Bundle.main.infoDictionary {
            if let name = info[key] as? String {
                return name
            }
        }
        return ""
    }
    
    
    /// 系统名称 iOS
    public static var systemName: String {
        return UIDevice.current.systemName
    }
    
    
    /// 系统版本号 13.1
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    
    /// UUID Vendor
    public static var uuid: String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    public static func generateUUID() -> String? {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        guard strRef != nil else {
            return nil
        }
        let uuidString = (strRef! as String).replacingOccurrences(of: "-", with: "")
        return uuidString
    }
    
    
    /// isJailBroken
    public static var isJailBroken: Bool {
        var jailBroken = false
        let cydiaPath = "/Applications/Cydia.app"
        let aptPath = "/private/var/lib/apt/"
        if FileManager.default.fileExists(atPath: cydiaPath) {
            jailBroken = true
        }
        if FileManager.default.fileExists(atPath: aptPath) {
            jailBroken = true
        }
        return jailBroken
    }
    
    
    /// 手机型号
    public static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        let models = [
            "iPhone1,1" : "iPhone 2G",
            "iPhone1,2" : "iPhone 3G",
            "iPhone2,1" : "iPhone 3GS",
            "iPhone3,1" : "iPhone 4 (A1332)",
            "iPhone3,2" : "iPhone 4 (A1332)",
            "iPhone3,3" : "iPhone 4 (A1349)",
            "iPhone4,1" : "iPhone 4S",
            "iPhone5,1" : "iPhone 5",
            "iPhone5,2" : "iPhone 5",
            "iPhone5,3" : "iPhone 5C",
            "iPhone5,4" : "iPhone 5C",
            "iPhone6,1" : "iPhone 5S",
            "iPhone6,2" : "iPhone 5S",
            "iPhone7,1" : "iPhone 6 Plus",
            "iPhone7,2" : "iPhone 6",
            "iPhone8,1" : "iPhone 6S",
            "iPhone8,2" : "iPhone 6S Plus",
            "iPhone8,4" : "iPhone SE",
            "iPhone9,1" : "iPhone 7",
            "iPhone9,3" : "iPhone 7",
            "iPhone9,2" : "iPhone 7 Plus",
            "iPhone9,4" : "iPhone 7 Plus",
            "iPhone10,1": "iPhone 8",
            "iPhone10,4": "iPhone 8",
            "iPhone10,2": "iPhone 8 Plus",
            "iPhone10,5": "iPhone 8 Plus",
            "iPhone10,3": "iPhone X",
            "iPhone10,6": "iPhone X",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS MAX",
            "iPhone11,6": "iPhone XS MAX",
            "iPhone11,8": "iPhone XR",
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            "iPhone12,8": "iPhone SE(2G)",
            "iPhone13,1": "iPhone 12 mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,4": "iPhone 13 mini",
            "iPhone14,5": "iPhone 13",
            "iPhone14,6": "iPhone SE(3G)",
            
            
            //iPod
            "iPod1,1" : "iPod Touch 1G (A1213)",
            "iPod2,1" : "iPod Touch 2G (A1288)",
            "iPod3,1" : "iPod Touch 3G (A1318)",
            "iPod4,1" : "iPod Touch 4G (A1367)",
            "iPod5,1" : "iPod Touch 5G (A1421/A1509)",
            "iPod7,1" : "iPod Touch 6G",
            
            //iPad
            "iPad1,1" : "iPad 1G (A1219/A1337)",
            "iPad2,1" : "iPad 2 (A1395)",
            "iPad2,2" : "iPad 2 (A1396)",
            "iPad2,3" : "iPad 2 (A1397)",
            "iPad2,4" : "iPad 2 (A1395+New Chip)",
            "iPad2,5" : "iPad Mini 1G (A1432)",
            "iPad2,6" : "iPad Mini 1G (A1454)",
            "iPad2,7" : "iPad Mini 1G (A1455)",
            
            "iPad3,1" : "iPad 3 (A1416)",
            "iPad3,2" : "iPad 3 (A1403)",
            "iPad3,3" : "iPad 3 (A1430)",
            "iPad3,4" : "iPad 4 (A1458)",
            "iPad3,5" : "iPad 4 (A1459)",
            "iPad3,6" : "iPad 4 (A1460)",
            
            "iPad4,1" : "iPad Air (A1474)",
            "iPad4,2" : "iPad Air (A1475)",
            "iPad4,3" : "iPad Air (A1476)",
            "iPad4,4" : "iPad Mini 2 (A1489)",
            "iPad4,5" : "iPad Mini 2 (A1490)",
            "iPad4,6" : "iPad Mini 2 (A1491)",
            "iPad4,7" : "iPad Mini 3",
            "iPad4,8" : "iPad Mini 3",
            "iPad4,9" : "iPad Mini 3",
            "iPad5,1" : "iPad Mini 4",
            "iPad5,2" : "iPad Mini 4",
            "iPad5,3" : "iPad Air 2",
            "iPad5,4" : "iPad Air 2",
            
            "iPad6,3" : "iPad Pro (9.7-inch)",
            "iPad6,4" : "iPad Pro (9.7-inch)",
            "iPad6,7" : "iPad Pro (12-inch)",
            "iPad6,8" : "iPad Pro (12-inch)",
            "iPad6,11": "iPad 5G",
            "iPad6,12": "iPad 5G",
            
            "iPad7,1" : "iPad Pro 2G (12-inch)",
            "iPad7,2" : "iPad Pro 2G (12-inch)",
            "iPad7,3" : "iPad Pro (10.5-inch)",
            "iPad7,4" : "iPad Pro (10.5-inch)",
            "iPad7,5" : "iPad 6G",
            "iPad7,6" : "iPad 6G",
            "iPad8,1" : "iPad Pro (11-inch)",
            "iPad8,2" : "iPad Pro (11-inch)",
            "iPad8,3" : "iPad Pro (11-inch)",
            "iPad8,4" : "iPad Pro (11-inch)",
            "iPad8,5" : "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,6" : "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,7" : "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,8" : "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,9" : "iPad Pro (11-inch) (2nd generation)",
            "iPad8,10": "iPad Pro (11-inch) (2nd generation)",
            "iPad8,11": "iPad Pro (12.9-inch) (4th generation)",
            "iPad8,12": "iPad Pro (12.9-inch) (4th generation)",
            
            "iPad11,1": "iPad Mini 5",
            "iPad11,2": "iPad Mini 5",
            "iPad11,3": "iPad Air 3",
            "iPad11,4": "iPad Air 3",
            
            
            "i386" : "iPhone Simulator",
            "x86_64" : "iPhone Simulator64"]
        
        if let mappedName = models[identifier] {
            return mappedName
        }
        return identifier
    }

}

//MARK: Locale
extension YFLDevice {
    
    //en_US(英文)、zh-Hant_US (繁体中文)，zh-Hans_US(简体中文)
    public static var locale: String {
        return NSLocale.current.identifier
    }
    
    public static var languageCode: String {
        if let code = NSLocale.current.languageCode {
            if code == "zh" {
                return scriptCode == "Hant" ? "cht" : code
            }
            return code
        }
        return ""
    }
    
    /// 语言代码
    /// - Parameter zhHant: 自定义的繁体中文代码， 默认 cht ， 可自定义tw等
    public static func languageCode(scriptCodeMap: [String: String] = ["Hant": "cht"]) -> String {
        if let code = NSLocale.current.languageCode {
            if let value = scriptCodeMap[scriptCode] {
                return value
            }
            return code
        }
        return ""
    }
    
    public static var isChinaMainland: Bool {
        return languageCode == "zh"
    }
    
    public static var isEnglish: Bool {
        return languageCode.contains("en")
    }
    
    /// For example, for the locale "zh-Hant-HK", returns "Hant".
    public static var scriptCode: String {
        return NSLocale.current.scriptCode ?? ""
    }
}
