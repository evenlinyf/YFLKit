//
//  YFLAlertAction.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import UIKit

public class YFLAlertAction: NSObject {
    
    public var button: YFLButton?
    public var handler: CompleteV?
    public var shouldAutoDismissAlert = true
    
    public init(button: YFLButton?, handler: CompleteV?) {
        super.init()
        self.button = button
        self.handler = handler
    }
    
    public convenience init(title: String, image: UIImage? = nil, style: YFLButton.Style = .normal, handler: CompleteV?) {
        let button = YFLButton(style: style)
        button.yfl
            .title(title)
            .image(image)
            .image(image, for: .highlighted)
            .font(size: 14)
            .color(handler == nil ? UIColor.lightGray : UIColor.darkGray)
        self.init(button: button, handler: handler)
    }
}
