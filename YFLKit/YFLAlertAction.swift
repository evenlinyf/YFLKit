//
//  YFLAlertAction.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import UIKit

public class YFLAlertAction: NSObject {
    public var button: YFLButton?
    public var handler: YFLComplete.V?
    public var shouldAutoDismissAlert = true
    
    public init(button: YFLButton?, handler: YFLComplete.V?) {
        super.init()
        self.button = button
        self.handler = handler
    }
    
    convenience init(title: String, image: UIImage? = nil, style: YFLButton.Style = .normal, handler: YFLComplete.V?) {
        let button = YFLButton(style: style)
        button.yfl
            .title(title)
            .image(image)
            .image(image, state: .highlighted)
            .font(size: 14, color: handler == nil ? UIColor.lightGray : UIColor.darkGray)
        self.init(button: button, handler: handler)
    }
}
