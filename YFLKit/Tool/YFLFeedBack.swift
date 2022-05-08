//
//  YFLFeedBack.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit

public struct YFLFeedBack {
    
    @available(iOS 10.0, *)
    static public func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let vibrateGenerator = UIImpactFeedbackGenerator(style: style)
        vibrateGenerator.prepare()
        vibrateGenerator.impactOccurred()
    }
    
    /// Vibrate FeedBack
    /// - Parameter type: Success  Warning  Error
    @available(iOS 10.0, *)
    static public func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    @available(iOS 10.0, *)
    static public func selectionFeedBack() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
