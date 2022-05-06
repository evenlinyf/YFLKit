//
//  Gallery.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/6.
//

import UIKit
import SnapKit

public class Gallery: UIView {

    /// 列数
    private(set) var colCount: Int = 1
    /// 行数
    private(set) var rowCount: Int = 1
    private(set) var childs: [UIView] = []
    public var horiSpace: CGFloat = 10
    public var vertiSpace:CGFloat = 10
    /// 是否在最后一行不满时自动添加剩余个数
    public var autoAddTrail = true
    
    public var horiDistribution: UIStackView.Distribution = .fillEqually
    public var vertiAlignment: UIStackView.Alignment = .fill
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(childs: [UIView], colCount: Int) {
        self.init(frame: CGRect.zero)
        self.childs = childs
        self.colCount = colCount
        self.rowCount = childs.count%colCount == 0 ? childs.count/colCount : (childs.count/colCount + 1)
    }
    
    public func layoutGallery() {
        var rows: [Row] = []
        
        for row in 0..<rowCount {
            var rowChilds: [UIView] = []
            for col in 0..<colCount {
                let index = indexFor(col: col, row: row)
                if index < childs.count {
                    let cell = childs[index]
                    rowChilds.append(cell)
                } else {
                    if self.autoAddTrail {
                        rowChilds.append(Expanded())
                    }
                }
            }
            let rowView = Row(childs: rowChilds).distribution(self.horiDistribution).spacing(self.horiSpace)
            rowView.resizeChilds()
            rows.append(rowView)
        }
        let colView = Column(childs: rows).alignment(self.vertiAlignment).spacing(self.vertiSpace)
        self.addSubview(colView)
        colView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func indexFor(col: Int, row: Int) -> Int {
        let index = row * colCount + col
        return index
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

