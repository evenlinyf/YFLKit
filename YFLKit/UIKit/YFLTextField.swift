//
//  YFLTextField.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import UIKit

public class YFLTextField: UITextField {
    
    public var needUnderline: Bool = false
    
    public var underlineColor: UIColor = UIColor.lightGray
    
    public var caretRect: CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .left
        self.clearButtonMode = .whileEditing
        textColor = UIColor.systemGray
        self.font = UIFont.systemFont(ofSize: 14)
    }
    
    public override func caretRect(for position: UITextPosition) -> CGRect {
        if let caretRect = caretRect {
            return caretRect
        }
        return super.caretRect(for: position)
    }
    
    public override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if needUnderline {
            let line = UIBezierPath()
            line.lineWidth = 0.7
            line.move(to: CGPoint(x: 0, y: self.height))
            line.addLine(to: CGPoint(x: self.width, y: self.height))
            underlineColor.setStroke()
            line.stroke()
        }
    }
}
