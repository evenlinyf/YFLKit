//
//  YFLAnimation.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

public enum YFLAnimationStyle {
    case nod, breathe, error, pop, alert
}

public enum AnimationKeyPath: String {
    case opacity = "opacity"
    case backgroundColor = "backgroundColor"// 背景颜色 参数：颜色 (id)[[UIColor redColor] CGColor]
    case cornerRadius = "cornerRadius"//  圆角 参数：圆角半径 5
    case borderWidth = "borderWidth"//  边框宽度 参数：边框宽度 5
    case bounds = "bounds"//  大小 参数：CGRect
    case contents = "contents"//  内容 参数：CGImage
    case contentsRect = "contentsRect"//  可视内容 参数：CGRect 值是0～1之间的小数
    case hidden = "hidden"//  是否隐藏
    case position = "position"//
    case shadowColor = "shadowColor"//
    case shadowOffset = "shadowOffset"//
    case shadowOpacity = "shadowOpacity"//
    case shadowRadius = "shadowRadius"//
    case xRotation = "transform.rotation.x"
    case yRotation = "transform.rotation.y"
    case zRotation = "transform.rotation.z"
    case xTranslation = "transform.translation.x"
    case yTranslation = "transform.translation.y"
    case zTranslation = "transform.translation.z"
    /// 移动到点 (100, 20)
    case pointTranslation = "transform.translation"
    case xScale = "transform.scale.x"
    case yScale = "transform.scale.y"
    case zScale = "transform.scale.z"
    case allScale = "transform.scale"
}

extension YFLWrapper where Base: UIView {
    
    public func animate(at path: AnimationKeyPath, duration: CFTimeInterval, values: [Any], count: Float = 1) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = path.rawValue
        animation.duration = duration
        animation.values = values
        animation.repeatCount = count
        base.layer.add(animation, forKey: path.rawValue)
    }
    
    public func animate(style: YFLAnimationStyle) {
        switch style {
        case .nod:
            nod()
        case .breathe:
            breathe()
        case .error:
            error()
        case .pop:
            pop()
        case .alert:
            alert()
        }
        
    }
    
    private func nod() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = AnimationKeyPath.zRotation.rawValue
        animation.duration = 0.18
        let angle = -60 * CGFloat.pi / 180
        animation.values = [0, angle, 0]
        animation.repeatCount = 1
        base.layer.add(animation, forKey: "nod")
    }
    
    private func breathe() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = AnimationKeyPath.allScale.rawValue
        animation.duration = 0.18
        animation.values = [0.8, 1.2, 1]
        animation.repeatCount = 1
        base.layer.add(animation, forKey: "breathe")
    }
    
    private func error() {
        if #available(iOS 10.0, *) {
            YFLFeedBack.vibrate(type: .warning)
        }
        let moveLength: CGFloat = 6
        let animation = CAKeyframeAnimation()
        animation.keyPath = AnimationKeyPath.xTranslation.rawValue
        animation.duration = 0.18
        animation.values = [0, -moveLength, moveLength, 0]
        animation.repeatCount = 2
        base.layer.add(animation, forKey: "error")
    }
    
    private func pop() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = AnimationKeyPath.yTranslation.rawValue
        animation.duration = 0.3
        animation.values = [150, -8, 0]
        animation.repeatCount = 1
        base.layer.add(animation, forKey: "pop")
    }
    
    private func alert() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = AnimationKeyPath.allScale.rawValue
        animation.duration = 0.3
        animation.values = [0.9, 1.03, 0.98, 1]
        animation.repeatCount = 1
        base.layer.add(animation, forKey: "alert")
    }
    
    public func removeAllAnimations() {
        base.layer.removeAllAnimations()
    }

}
