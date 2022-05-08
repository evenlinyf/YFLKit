//
//  Column.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/6.
//

import UIKit
import SnapKit

public class Column: UIStackView {
    
    public convenience init(childs: [UIView]) {
        self.init(arrangedSubviews: childs)
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .equalSpacing
        self.spacing = 10
    }
    
    public func resizeChilds() {
        for child in self.arrangedSubviews {
            child.snp.makeConstraints { make in
                if child.yfl.width > 0 {
                    make.width.equalTo(child.yfl.width)
                }
                if child.yfl.height > 0 {
                    make.height.equalTo(child.yfl.height)
                }
            }
        }
    }
    
    /// 设置偏左, 居中, 偏右
    /// - Parameter alignment: default .leading
    @discardableResult
    public func alignment(_ alignment: UIStackView.Alignment) -> Column {
        self.alignment = alignment
        return self
    }
    
    
    /// 设置布局, 上下等间距, 等宽排布还是如何
    /// - Parameter distribution: default .equalSpacing
    @discardableResult
    public func distribution(_ distribution: UIStackView.Distribution) -> Column {
        self.distribution = distribution
        return self
    }
    
    
    /// 设置间距
    /// - Parameter spacing: default is 10
    @discardableResult
    public func spacing(_ spacing: CGFloat) -> Column {
        self.spacing = spacing
        return self
    }
    
}
