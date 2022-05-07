//
//  YFLAuthManager.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import UIKit
import Photos
import AVFoundation

public struct YFLAuthManager {
    
    /// 获取相机麦克风权限状态
    /// - Parameter mediaType: 相机 .video 麦克风 .audio
    /// - Returns: status
    public func authorizationStatus(mediaType: AVMediaType) -> AVAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        return status
    }
    
    
    /// 请求访问相机/麦克风
    /// - Parameter mediaType: 相机 .video 麦克风 .audio
    public func requestMediaAuth(mediaType: AVMediaType, complete: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: mediaType) { isSuccess in
            complete(isSuccess)
        }
    }
    
    
    /// 相册访问权限状态
    /// - Returns: status
    public func photoLibraryAuthorizationStatus() -> PHAuthorizationStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        return status
    }
    
    
    /// 请求相册访问权限
    /// - Parameter complete: 回调状态
    public func requestPhotoLibraryAuthorization(complete: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            complete(status)
        }
    }
    
    
    /// 打开系统设置页面
    public func openSystemSetting() {
        guard let systemSettingUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(systemSettingUrl) {
            UIApplication.shared.openURL(systemSettingUrl)
        }
    }
    
}
