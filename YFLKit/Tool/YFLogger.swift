//
//  YFLogger.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import Foundation

public var enableYFLog: Bool = true
public var enableSaveLog: Bool = false

public func YFLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
#if DEBUG
    guard enableYFLog else { return }
    let time = Date().yfl.timeString("yyyy-MM-dd HH:mm:ss.SSS")
    let finalString = "📔[\(time)] \((file as NSString).lastPathComponent)[\(line)].\(method)\n\(message)"
    YFLogManager.saveLog(finalString)
    print(finalString)
#endif
}

public class YFLogManager: NSObject {

    public static var logPath: String = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("log-\(Date().yfl.timeString("yyyy-MM-dd")).txt").path
    
    public static func saveLog(_ log: String) {
        if !hasLog() {
            FileManager.default.createFile(atPath: logPath, contents: nil)
        }
        guard let fileHandler = FileHandle(forWritingAtPath: logPath) else { return }
        defer {
            fileHandler.closeFile()
        }
        fileHandler.seekToEndOfFile()
        if let data = ("\n\(log)\n").data(using: .utf8) {
            fileHandler.write(data)
        }
    }
    
    public static func clearLog() {
        if hasLog() {
            try? FileManager.default.removeItem(atPath: logPath)
        }
    }
    
    public static func hasLog() -> Bool {
        return FileManager.default.fileExists(atPath: logPath)
    }
    
    public func logString() -> String?{
        guard Self.hasLog() else { return nil }
        let data = try? Data(contentsOf: URL(fileURLWithPath: Self.logPath))
        if let data = data, let string = String(data: data, encoding: .utf8) { return string }
        return nil
    }
    
    
    public func showLog() {
        guard Self.hasLog() else { return }
        guard UIApplication.shared.yfl.rootVC != nil else { return }
        let fileUrl = URL(fileURLWithPath: YFLogManager.logPath)
        let docController = UIDocumentInteractionController(url: fileUrl)
        docController.delegate = self
        docController.presentPreview(animated: true)
    }
}

extension YFLogManager: UIDocumentInteractionControllerDelegate {
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.yfl.rootVC!
    }
}
