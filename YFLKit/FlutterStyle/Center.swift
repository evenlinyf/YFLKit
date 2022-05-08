//
//  Center.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/6.
//

import UIKit
import SnapKit

public class Center: UIView {
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(child: UIView) {
        self.init(frame: .zero)
        self.addSubview(child)
        
        child.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualToSuperview()
            make.right.bottom.lessThanOrEqualToSuperview()
            if child.yfl.width > 0 {
                make.width.equalTo(child.yfl.width)
            }
            if child.yfl.height > 0 {
                make.height.equalTo(child.yfl.height)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

