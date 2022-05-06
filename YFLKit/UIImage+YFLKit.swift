//
//  UIImage+YFLKit.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import UIKit
import Foundation

extension UIImage: YFLCompatible {}

extension YFLWrapper where Base: UIImage {
    
    public func draw(in rect: CGRect, imageRect: CGRect, bgColor: UIColor?, cornerRadius: CGFloat?) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius ?? 0)
        path.addClip()

        if let color = bgColor {
            color.setFill()
            path.fill()
        }
        
        base.draw(in: imageRect)
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return contextImage ?? nil
    }
    
    //图片等比例缩小到rect中
    public func draw(in rect: CGRect, scale: CGFloat, bgColor: UIColor?, cornerRadius: CGFloat?) -> UIImage? {
        guard scale <= 1 else {
            return nil
        }
        var imageWidth: CGFloat = 0
        var imageHeight: CGFloat = 0
        
        //定宽度, 看高度是否超出rect的高度
        let dWHeight = base.size.height * (rect.width/base.size.width)
        
        //如果高度超过rect的高度, 那么应该让image的高度和rect高度相等, image的宽度等比例缩小
        if dWHeight > rect.height {
            imageHeight = rect.height
            imageWidth = base.size.width * (rect.height/base.size.height)
        } else {
            //定宽度, 高度等比例缩小
            imageWidth = rect.width
            imageHeight = base.size.height * (rect.width/base.size.width)
        }
        //根据scale调整大小
        imageWidth = imageWidth * scale
        imageHeight = imageHeight * scale
        
        //居中
        let x = (rect.width - imageWidth)/2
        let y = (rect.width - imageHeight)/2
        let imageRect = CGRect(x: x, y: y, width: imageWidth, height: imageHeight)
        return self.draw(in: rect, imageRect: imageRect, bgColor: bgColor, cornerRadius: cornerRadius)
    }
    
    public func toGaussianBlurImage(value: CGFloat = 20) -> UIImage? {
        
        guard let ciImage = CIImage(image: base) else { return nil }
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        blurFilter.setValue(ciImage, forKey: "inputImage")
        blurFilter.setValue(value, forKey: "inputRadius")
        guard let outputImage = blurFilter.outputImage else { return nil }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    public func draw(edgeInsets: UIEdgeInsets, imageSize: CGSize? = nil) -> UIImage? {
        let imageWidth = imageSize != nil ? imageSize!.width : base.size.width
        let imageHeight = imageSize != nil ? imageSize!.height : base.size.height
        let rect = CGRect(x: 0, y: 0, width: imageWidth + edgeInsets.left + edgeInsets.right, height: imageHeight + edgeInsets.top + edgeInsets.bottom)
        let imageRect = CGRect(x: edgeInsets.left, y: edgeInsets.top, width: imageWidth, height: imageHeight)
        
        return draw(in: rect, imageRect: imageRect, bgColor: nil, cornerRadius: nil)
    }
    
    public func resize(width: CGFloat, height: CGFloat) -> UIImage? {
        return draw(edgeInsets: .zero, imageSize: CGSize(width: width, height: height))
    }
    
    /// 改变图片的颜色
    /// - Parameter color: 想要图片变成的颜色
    @available(iOS 13.0, *)
    public func tint(_ color: UIColor) -> UIImage {
        return base.withTintColor(color)
    }
}
