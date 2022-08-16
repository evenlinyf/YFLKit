//
//  Row.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/6.
//

import UIKit
import SnapKit

public class Row: UIStackView {

    public convenience init(childs: [UIView]) {
        self.init(arrangedSubviews: childs)
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .equalSpacing
        self.spacing = 10
    }
    
    public func resizeChilds() {
        for child in self.arrangedSubviews {
            if child is UILabel { continue }
            child.snp.makeConstraints { make in
                if child.width > 0 {
                    make.width.equalTo(child.width)
                }
                if child.height > 0 {
                    make.height.equalTo(child.height)
                }
            }
        }
    }
    
    @discardableResult
    public func alignment(_ alignment: UIStackView.Alignment) -> Row {
        self.alignment = alignment
        return self
    }
    
    @discardableResult
    public func distribution(_ distribution: UIStackView.Distribution) -> Row {
        self.distribution = distribution
        return self
    }
    
    @discardableResult
    public func spacing(_ spacing: CGFloat) -> Row {
        self.spacing = spacing
        return self
    }

}
