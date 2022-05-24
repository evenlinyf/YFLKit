//
//  YFLScreenMonitor.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import Foundation

public class YFLScreenMonitor: NSObject {
    
    public enum UserActionType {
        ///截屏
        case screenShot
        ///录屏
        case screenCaptured
    }
    
    private var callBack: CompleteT<UserActionType>?
    
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveScreenShotNotify(_:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveScreenCaptureStatusChanged), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// 开始监测截屏录屏事件
    /// - Parameter actionDetected: 截屏录屏事件回调
    public func startMonitorScreen(_ actionDetected: CompleteT<UserActionType>?) {
        self.callBack = actionDetected
    }
    
    /// 是否正在录屏
    public func isScreenBeingCaptured() -> Bool {
        return UIScreen.main.isCaptured
    }
    
    @objc func didReceiveScreenShotNotify(_ notify: Notification) {
        self.callBack?(.screenShot)
    }
    
    @objc func didReceiveScreenCaptureStatusChanged() {
        self.callBack?(.screenCaptured)
    }
    
    
}
