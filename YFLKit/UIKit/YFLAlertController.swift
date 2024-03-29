//
//  YFLAlertController.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import UIKit

public class YFLAlertController: UIViewController {
    
    private var preViewController: UIViewController?
    
    /// 系统样式还是圆角矩形样式
    public var style: YFLAlertController.Style = .alert
    
    /// 弹窗在屏幕上的位置
    public var position: YFLAlertController.Position = .center
    
    /// 点击mask或者下滑alert退出弹框
    public var tapToDismiss: Bool = true
    
    /// 是否需要右上角的取消按钮
    public var needCancel: Bool = false
    
    /// 弹框宽度
    public var contentWidth: CGFloat?
    
    /// 需要展示的自定义Content内容视图
    public var contentView: UIView?
    
    /// 增加的按钮
    private(set) var actions: [YFLAlertAction] = []
    
    /// 图片边距
    public var imageEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
    
    /// 标题边距
    public var titleEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    
    /// 详情边距
    public var detailEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 15, right: 10)
    
    /// 自定义视图边距
    public var contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// Alert 圆角
    public var cornerRadius: CGFloat?
    
    /// 自定义AlertContent位置, 请确保可以定位
    public var customPosition: UIEdgeInsets?
    
    private var tapGesture: UITapGestureRecognizer?
    
    /// 透明黑色背景视图
    private let maskView: UIView = UIView()
    
    /// 弹框主视图
    public let alertContentView: UIView = UIView()
    
    /// 自定义视图的父视图
    private let popContent: UIView = UIView()
    private let actionContent: UIView = UIView()
    private let space: CGFloat = 18
    
    
    /// 存放图片的视图
    public let imageContent = UIView()
    /// 图片
    public lazy var imageView: UIImageView? = {
        let iv = UIImageView()
        imageContent.addSubview(iv)
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { make in
            make.edges.equalTo(imageEdgeInsets)
            make.centerX.equalToSuperview()
        }
        return iv
    }()
    
    private var cusDismissAction: CompleteV?
    
    public let textContent = UIView()
    
    /// 标题
    public lazy var textLabel: UILabel? = {
        let label = UILabel()
        label.yfl
            .color(.darkGray)
            .font(size: 15, isBold: true)
            .numberOfLines(0)
            .alignment(.center)
        textContent.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.edges.equalTo(titleEdgeInsets)
        }
        return label
    }()
    
    public let textDetailContent = UIView()
    /// 详细内容
    public lazy var detailTextLabel: UILabel? = {
        let detailLabel = UILabel()
        detailLabel.yfl
            .color(.lightGray)
            .numberOfLines(0)
            .font(size: 13)
        textDetailContent.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(detailEdgeInsets.top)
            make.left.greaterThanOrEqualTo(detailEdgeInsets.left)
            make.right.lessThanOrEqualTo(-detailEdgeInsets.right)
            make.bottom.equalTo(-detailEdgeInsets.bottom)
        }
        return detailLabel
    }()
    
    public let backgroundImageView: UIImageView = UIImageView()
    public let topBgImageView: UIImageView = UIImageView()
    
    /// 取消按钮
    public var cancelButton: YFLButton?
    
    public convenience init(preferredStyle: YFLAlertController.Style, position: YFLAlertController.Position = .center) {
        self.init()
        self.alertContentView.backgroundColor = .white
        self.style = preferredStyle
        self.position = position
    }
    
    public convenience init(title: String?, message: String?, image: UIImage? = nil) {
        self.init(preferredStyle: .alert, position: .center)
        self.tapToDismiss = true
        self.textLabel?.text = title
        self.detailTextLabel?.text = message
        if let image = image {
            self.imageView?.image = image
        }
    }
    
    public convenience init(contentView: UIView?) {
        self.init(preferredStyle: .alert, position: .center)
        if let contentView = contentView {
            self.contentView = contentView
        }
    }
    
//MARK: Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        if self.contentWidth == nil {
            contentWidth = position.width
            if let cWidth = contentView?.width {
                if cWidth > 0 {
                    contentWidth = cWidth + contentEdgeInsets.left + contentEdgeInsets.right
                } else {
                    contentView?.width = contentWidth!
                }
            } else {
                contentView?.width = contentWidth!
            }
        }
        configMaskView()
        configContentView()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.contentAnimation()
        }
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return self.preViewController?.preferredStatusBarStyle ?? .default
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    public func addAction(_ action: YFLAlertAction?) {
        guard let action = action else { return }
        self.actions.append(action)
    }
    
    private func addCancel() {
        cancelButton = YFLButton(style: .normal)
        cancelButton?.margin = 0
        guard let cancelButton = cancelButton else {
            return
        }
        
        cancelButton.contentMode = .scaleAspectFit
        if let cancelImage = YFLAlertConfig.cancelImage {
            cancelButton.setImage(cancelImage, for: .normal)
        } else {
            cancelButton.yfl
                .title("×")
                .font(size: 14)
                .color(.lightGray)
        }
        alertContentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.right.top.equalTo(0)
            make.width.height.equalTo(40)
        }
        cancelButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    public func setCancelAction(_ action: CompleteV?) {
        self.cusDismissAction = action
    }
    
}

//MARK: actions
extension YFLAlertController {
    
    public func showInViewController(_ viewController: UIViewController) {
        self.modalPresentationStyle = .overCurrentContext
        self.preViewController = viewController
        var controller = viewController
        if let navControl = viewController.navigationController {
            controller = navControl
        }
        if let tabControl = viewController.tabBarController {
            controller = tabControl
        }
        guard controller.presentedViewController == nil else {
            YFLog("⚠️ attempt to present viewController over the viewController which has presentedViewController")
            return
        }
        controller.present(self, animated: false, completion: nil)
    }
    
    @objc private func dismissAction() {
        self.dismiss(animated: false) {
            self.cusDismissAction?()
        }
    }
    
    @objc private func dismissAnimatedAction() {
        UIView.animate(withDuration: 0.06) {
            self.maskView.backgroundColor = UIColor(hex: 0x000000, alpha: 0)
        }
        self.dismissAction()
    }
    
    @objc private func actionClicked(_ sender: UIButton) {
        _ = self.actions.first { action in
            if action.button == sender {
                if let handler = action.handler {
                    if action.shouldAutoDismissAlert {
                        self.dismiss(animated: false) {
                            handler()
                        }
                    } else {
                        handler()
                    }
                } else {
                    self.dismissAction()
                }
                return true
            }
            return false
        }
    }
    
    private func contentAnimation() {
        maskView.backgroundColor = UIColor(hex: 0x000000, alpha: 0)
        UIView.animate(withDuration: 0.18) {
            self.maskView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.3)
        }
        alertContentView.yfl.animate(style: position == .bottom ? .pop : .alert)
    }
    
}

//MARK: UI 设置
extension YFLAlertController {
    //配置 maskView， 透明黑色背景， 透明度0.5
    private func configMaskView()  {
        view.backgroundColor = .clear
        view.addSubview(maskView)
        maskView.backgroundColor = UIColor(hex: 0x000000, alpha: 0)
        maskView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        //是否需要点击黑色背景退出弹框
        if self.tapToDismiss {
            self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAnimatedAction))
            if let tap = tapGesture {
                maskView.addGestureRecognizer(tap)
            }
        }
    }
    
    private func configContentView() {
        
        alertContentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        alertContentView.addSubview(topBgImageView)
        topBgImageView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
        }
        
        alertContentView.addSubview(imageContent)
        imageContent.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
        }
        
        alertContentView.addSubview(textContent)
        textContent.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageContent.snp.bottom)
        }
        
        alertContentView.addSubview(textDetailContent)
        textDetailContent.snp.makeConstraints { make in
            make.top.equalTo(textContent.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(topBgImageView.snp.bottom)
        }
        
        alertContentView.addSubview(popContent)
        popContent.snp.makeConstraints { make in
            make.top.equalTo(textDetailContent.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        if let contentView = contentView {
            popContent.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(contentEdgeInsets)
            }
        }
        
        alertContentView.addSubview(actionContent)
        actionContent.snp.makeConstraints { make in
            make.top.equalTo(popContent.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            if self.position == .bottom {
                make.bottom.equalTo(-30)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        configActionContent()
        
        if needCancel {
            addCancel()
        }
        
        view.addSubview(alertContentView)
        alertContentView.width = contentWidth!
        if let cusPosition = customPosition {
            alertContentView.snp.makeConstraints { make in
                make.width.equalTo(contentWidth!)
                if cusPosition.top > 0 {
                    make.top.equalTo(cusPosition.top)
                }
                if cusPosition.left > 0 {
                    make.left.equalTo(cusPosition.left)
                }
                if cusPosition.bottom > 0 {
                    make.bottom.equalTo(-cusPosition.bottom)
                }
                if cusPosition.right > 0 {
                    make.right.equalTo(-cusPosition.right)
                }
            }
        } else {
            switch position {
            case .golden:
                let centerYOffset: CGFloat = view.height * (0.5 - 1 + 0.618)
                alertContentView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.width.equalTo(contentWidth!)
                    make.centerY.equalToSuperview().offset(-centerYOffset)
                }
            case .center:
                alertContentView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(contentWidth!)
                }
            case .bottom:
                alertContentView.snp.makeConstraints { make in
                    //为了切掉圆角...
                    make.bottom.equalTo(10)
                    make.left.right.equalToSuperview()
                    make.width.equalTo(self.view.width)
                }
            }
        }
        
        alertContentView.layer.cornerRadius = self.cornerRadius ?? YFLAlertConfig.cornerRadius
        alertContentView.layer.masksToBounds = false
    }
    
    //Actions 约束
    private func configActionContent() {
        guard actions.count > 0 else { return }
        let actionHeight: CGFloat = 40
        let count = actions.count
        if count == 1 {
            if let button = actions.first!.button {
                button.addTarget(self, action: #selector(actionClicked(_:)), for: .touchUpInside)
                actionContent.addSubview(button)
                button.snp.makeConstraints { make in
                    make.height.equalTo(actionHeight)
                    if style == .roundedRect {
                        make.top.equalToSuperview()
                        make.centerX.equalToSuperview()
                        make.bottom.equalTo(-space)
                        make.width.equalTo(contentWidth! * YFLAlertConfig.buttonRatio)
                    } else {
                        make.edges.equalTo(UIEdgeInsets.zero)
                    }
                }
            }
            return
        }
        
        if count == 2 && style != .actionSheet {
            if let button1 = actions.first!.button, let button2 = actions.last!.button {
                button1.addTarget(self, action: #selector(actionClicked(_:)), for: .touchUpInside)
                button2.addTarget(self, action: #selector(actionClicked(_:)), for: .touchUpInside)
                actionContent.addSubview(button1)
                actionContent.addSubview(button2)
                if self.style == .roundedRect {
                    let buttonMargin = 0.09 * contentWidth! //中间小
//                    let buttonMargin = 0.066 * contentWidth //两边小
                    button1.snp.makeConstraints { make in
                        make.top.equalToSuperview()
                        make.bottom.equalTo(-space)
                        make.width.equalTo(contentWidth! * (1-0.618))
                        make.left.equalTo(buttonMargin)
                        make.height.equalTo(actionHeight)
                    }
                    button2.snp.makeConstraints { make in
                        make.centerY.equalTo(button1.snp.centerY)
                        make.height.width.equalTo(button1)
                        make.right.equalTo(-buttonMargin)
                    }
                } else {
                    //alert style
                    let horiLineView = lineView()
                    actionContent.addSubview(horiLineView)
                    horiLineView.snp.makeConstraints { make in
                        make.left.top.right.equalTo(0)
                        make.height.equalTo(horiLineView.height)
                    }
                    button1.snp.makeConstraints { make in
                        make.left.equalToSuperview()
                        make.top.equalTo(horiLineView.snp.bottom)
                        make.height.equalTo(actionHeight)
                        make.bottom.equalToSuperview()
                    }
                    
                    let vertiLine = lineView(vertical: true)
                    actionContent.addSubview(vertiLine)
                    vertiLine.snp.makeConstraints { make in
                        make.left.equalTo(button1.snp.right)
                        make.top.equalTo(horiLineView.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.width.equalTo(vertiLine.width)
                        make.height.equalTo(actionHeight)
                    }
                    
                    button2.snp.makeConstraints { make in
                        make.left.equalTo(vertiLine.snp.right)
                        make.top.equalTo(horiLineView.snp.bottom)
                        make.height.equalTo(actionHeight)
                        make.width.equalTo(button1)
                        make.right.equalToSuperview()
                        make.bottom.equalToSuperview()
                    }
                }
            }
            return
        }
        
        var topView: UIView?
        for action in actions {
            let isLast = actions.last == action
            if let button = action.button {
                let line = lineView()
                if topView == nil {
                    line.backgroundColor = .clear
                }
                actionContent.addSubview(line)
                line.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(line.height)
                    if let topView = topView {
                        make.top.equalTo(topView.snp.bottom)
                    } else {
                        make.top.equalToSuperview()
                    }
                }
                topView = line
                
                actionContent.addSubview(button)
                button.addTarget(self, action: #selector(actionClicked(_:)), for: .touchUpInside)
                button.snp.makeConstraints { make in
                    make.left.right.equalTo(0)
                    make.height.equalTo(actionHeight)
                    if let topView = topView {
                        make.top.equalTo(topView.snp.bottom)
                    } else {
                        make.top.equalToSuperview()
                    }
                    if isLast {
                        make.bottom.equalToSuperview()
                    }
                }
                topView = button
            }
            
        }
    }
    
    private func lineView(vertical: Bool = false) -> UIView {
        let lineWidth: CGFloat = 1
        let line = UIView(frame: CGRect(x: 0, y: 0, width: contentWidth!, height: lineWidth))
        line.backgroundColor = UIColor(hex: 0xEDEDED)
        if vertical {
            line.frame = CGRect(x: 0, y: 0, width: lineWidth, height: 40)
        } else {
            line.frame = CGRect(x: 0, y: 0, width: contentWidth!, height: lineWidth)
        }
        return line
    }
    
}


extension YFLAlertController {
    public enum Style {
        /// 横向排列， 两个以上纵向排列
        case alert
        /// 纵向排列
        case actionSheet
        /// 圆角矩形， 横向排列
        case roundedRect
    }
    
    public enum Position {
        ///centerY在黄金分割点
        case golden
        ///上下左右居中
        case center
        ///底部
        case bottom
        
        var width: CGFloat {
            get {
                let screenWidth = UIScreen.main.bounds.size.width
                switch self {
                case .golden, .center:
                    return screenWidth > 400 ? screenWidth * 0.631 : screenWidth * 0.72
                case .bottom:
                    return screenWidth
                }
            }
        }
    }
}

//MARK: Static func
extension YFLAlertController {
    
    public static func alertController(title: String?, detail: String? = nil, image: UIImage?, actionTitle: String, needCancel: Bool = true, complete: (() -> Void)?) -> YFLAlertController {
        
        let alert = YFLAlertController(preferredStyle: .roundedRect)
        
        if let title = title {
            alert.textLabel?.text = title
        }
        if let detail = detail {
            alert.detailTextLabel?.text = detail
            alert.detailTextLabel?.textAlignment = .center
        }
        if let image = image {
            alert.imageView?.image = image
        }
        alert.needCancel = needCancel
        alert.tapToDismiss = false

        let confirmBtn = YFLButton(style: .full)
        confirmBtn.yfl
            .font(size: 14)
            .color(.white)
            .backgroundColor(YFLAlertConfig.themeColor)
            .title(actionTitle)
        
        let confirmAction = YFLAlertAction(button: confirmBtn) {
            complete?()
        }
        alert.addAction(confirmAction)
        return alert
    }
    
    /// 弹窗
    /// - Parameters:
    ///   - vc: 控制器
    ///   - title: 标题
    ///   - detail: 详情
    ///   - image: 图片
    ///   - actionTitle: 确认按钮
    ///   - needCancel: 是否需要取消
    ///   - complete: 确认按钮点击事件
    public static func alert(in vc: UIViewController?, title: String?, detail: String?, image: UIImage?, actionTitle: String, needCancel: Bool = true, complete: (() -> Void)?) {
        guard let vc = vc else {
            return
        }
        let alert = self.alertController(title: title, detail: detail, image: image, actionTitle: actionTitle, needCancel: needCancel, complete: complete)
        alert.showInViewController(vc)
    }
    
    
    /// 简单的选择器， 传入需要选择的标题数组， 点击返回标题
    /// - Parameters:
    ///   - vc: 控制器
    ///   - title: 标题
    ///   - message: 信息
    ///   - image: 图片
    ///   - actions: 所有的操作
    ///   - complete: 点击回调操作名
    public static func showSelectActionSheet(in vc: UIViewController, title: String?, message: String?, image: UIImage?, actions: [String], complete: @escaping (String) -> Void) {
        let alert = YFLAlertController(preferredStyle: .actionSheet, position: .center)
        alert.textLabel?.text = title
        alert.detailTextLabel?.text = message
        if let image = image {
            alert.imageView?.image = image
        }
        for action in actions {
            let puAction = YFLAlertAction(title: action, image: nil, style: .normal) {
                complete(action)
            }
            alert.addAction(puAction)
        }
        alert.showInViewController(vc)
    }
}

//MARK: move with finger
extension YFLAlertController {
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alertContentView.transform = .identity
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentLocation = touch.location(in: view)
        let previousLocation = touch.previousLocation(in: view)
        var x = currentLocation.x - previousLocation.x
        var y = currentLocation.y - previousLocation.y
        if case .bottom = position {
            x = 0
            if y < 0 { y = 0 }
        }
        
        alertContentView.transform = CGAffineTransformTranslate(alertContentView.transform, x, y)
        if y > 36 {
            dismissAnimatedAction()
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        alertContentView.transform = .identity
    }
}
