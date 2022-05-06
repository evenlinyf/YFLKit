//
//  Expanded.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/6.
//

import UIKit

public class Expanded: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.yfl.setStretchable(true, for: .horizontal)
        self.yfl.setStretchable(true, for: .vertical)
        self.yfl.setCompressible(true, for: .horizontal)
        self.yfl.setCompressible(true, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
