//
//  YFLButton.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import UIKit

public class YFLButton: UIButton {
    
    /// 用于展示Image， 解决自带ImageView图片太小时会有边距的问题
    public lazy var sourceView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        return imageView
    }()
    
    public var radius: CGFloat?
    public var space: CGFloat = 3
    public var borderColor: UIColor?
    public var edgeInsets: UIEdgeInsets?
    
    public var buttonWidth: CGFloat {
        get {
            var btnWidth: CGFloat = 0
            if let title = self.titleLabel?.text {
                let titleWidth = title.yfl.size(with: titleLabel!.font).width
                btnWidth += titleWidth
            }
            if let image = self.imageView?.image {
                btnWidth += image.size.width
            }
            if let edgeInsets = edgeInsets {
                btnWidth += edgeInsets.left
                btnWidth += edgeInsets.right
            } else {
                btnWidth += 2 * margin
            }
            btnWidth += 3
            return btnWidth
        }
    }
    
    /// 便于确定cell中的button
    public var indexPath: IndexPath = IndexPath.init(row: 0, section: 0)
    
    /// 左右间距
    public var margin: CGFloat = 8
    
    private(set) var imagePosition: ImagePosition = .left
    private(set) var style: Style = .normal
    private var action: CompleteT<YFLButton>?
    
    public convenience init(style: Style?, imagePosition: ImagePosition? = .left) {
        self.init(type: .custom)
        self.imagePosition = imagePosition ?? .left
        if let style = style {
            self.style = style
        }
        if self.style == .normal {
            margin = 0
        }
    }
    
    public func setBgColor(_ color: UIColor?, for state: UIControl.State) {
        guard let color = color else { return }
        let bgImage = color.yfl.toImage(size: self.frame.size)
        self.setBackgroundImage(bgImage, for: state)
    }
    
    public func setAction(_ action: @escaping CompleteT<YFLButton>) {
        self.removeTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        self.action = action
    }
    
    
    @objc private func clickAction(_ sender: YFLButton) {
        self.action?(sender)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var needAdjustment = false
        if let count = self.title(for: .normal)?.count {
            if count > 0 && imageView?.image != nil {
                needAdjustment = true
            }
        }
        
        if needAdjustment {
            if let imageSize = self.imageView?.image?.size,let titleSize = self.titleLabel?.frame.size {
                switch imagePosition {
                case .left:
                    self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space/2, bottom: 0, right: -space/2)
                    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2, bottom: 0, right: space/2)
                case .right:
                    self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width - space/2, bottom: 0, right: imageSize.width + space/2)
                    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + space/2, bottom: 0, right: -titleSize.width - space/2)
                case .top:
                    self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + space/2), right: 0)
                    self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + space/2), left: 0, bottom: 0, right: -titleSize.width)
                case .bottom:
                    self.titleEdgeInsets = UIEdgeInsets(top: -imageSize.height - space/2, left: -imageSize.width, bottom: 0, right: 0)
                    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleSize.height - space/2, right: -titleSize.width)
                }
            }
        }
        
        self.contentEdgeInsets = edgeInsets ?? UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        
        switch style {
        case .normal:
            if let radius = radius {
                self.yfl.makeRoundCorner(radius)
            }
            break
        case .full:
            self.yfl.makeRoundCorner(radius ?? self.yfl.height/2)
        case .circle:
            self.yfl.setCornerRadius(radius ?? self.yfl.height/2)
            self.layer.borderColor = borderColor != nil ? borderColor!.cgColor : self.currentTitleColor.cgColor
            self.layer.borderWidth = 1
        }
    }

}

//MARK: Enumerates
extension YFLButton {
    public enum ImagePosition {
        case left
        case top
        case right
        case bottom
    }
    
    public enum Style {
        case normal
        case full
        case circle
    }
}
