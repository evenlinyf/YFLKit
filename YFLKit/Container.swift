//
//  Container.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/6.
//

import UIKit

public class Container: UIView {
    
    public enum Alignment {
        case left
        case center
        case right
    }
    
    private(set) var child: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(child: UIView?, edgeInsets: UIEdgeInsets? = nil, alignment: Alignment = .center) {
        self.init(frame: CGRect.zero)
        guard let child = child else {
            return
        }
        self.child = child
        self.addSubview(child)
        let edge = edgeInsets ?? UIEdgeInsets.zero
        child.snp.makeConstraints { make in
            switch alignment {
            case .left:
                make.left.equalTo(edge.left)
                make.top.equalTo(edge.top)
                make.bottom.equalTo(-edge.bottom)
                make.right.lessThanOrEqualTo(-edge.right)
            case .center:
                make.edges.equalTo(edge)
            case .right:
                make.left.greaterThanOrEqualTo(edge.left)
                make.top.equalTo(edge.top)
                make.bottom.equalTo(-edge.bottom)
                make.right.equalTo(-edge.right)
            }
        }
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> Container {
        guard child != nil else {return self}
        child!.snp.makeConstraints { make in
            make.width.equalTo(width)
        }
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> Container {
        guard child != nil else { return self }
        child!.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        return self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

