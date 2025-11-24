//
//  MultiRowView.swift
//  SwiftNest
//
//  Created by Duanhu on 2025/5/12.
//

import UIKit
import JKSwiftExtension

public class MultiRowConfiguration: NSObject {
    
    nonisolated(unsafe) private static var single = MultiRowConfiguration()
    
    public class func `default`() -> MultiRowConfiguration {
        MultiRowConfiguration.single
    }
    
    public class func reset() {
        MultiRowConfiguration.single = MultiRowConfiguration()
    }
    
    public var insets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
    
    public var themeColor: UIColor = .black
    
    public var titleColor: UIColor = .black
    public var titleFont: UIFont = .medium(16)
    
    public var detailsColor: UIColor = .black
    public var detailsFont: UIFont = .regular(14)
    
    public var textFieldColor: UIColor = .black
    public var textFieldFont: UIFont = .regular(14)
    
    public var textViewColor: UIColor = .black
    public var textViewFont: UIFont = .regular(14)
    
    public var valueColor: UIColor = .gray
    public var valueFont: UIFont = .regular(14)
    
    /// 黑色箭头
    public var arrowImage = UIImage(named: "icon_row_arrow_right")
    
    public var switchOnImage = UIImage(named: "icon_row_switch_on")
    
    public var switchOffImage = UIImage(named: "icon_row_switch_off")
    
    /// 输入密码时，开启/关闭密文的小眼睛
    public var eyeOffImage = UIImage(named: "icon_row_eye_off")
    
    /// 输入密码时，开启/关闭密文的小眼睛
    public var eyeOnImage = UIImage(named: "icon_row_eye_on")
    
    /// 问号按钮
    public var questionMarkImage = UIImage(named: "icon_row_question_mark")
}

public enum MultiTrailerType {
    case none
    case password // 密码输入框
    case verificationCode  // 获取验证码
    case arrow // 箭头
    case `switch`
    case icon(UIImage?)
    case icon2(UIImage?, UIImage?)
}

public extension MultiRowView {
    /// 右侧对齐方式
    enum TrailerVerAlign {
        case parent, title, details, textField
    }
}

public extension MultiRowView {
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var titleAttr: NSAttributedString? {
        get {
            return titleLabel.attributedText
        }
        set {
            titleLabel.attributedText = newValue
        }
    }
    
    var details: String? {
        get {
            return detailsLabel.text
        }
        set {
            detailsLabel.text = newValue
        }
    }
    
    var detailsAttr: NSAttributedString? {
        get {
            return detailsLabel.attributedText
        }
        set {
            detailsLabel.attributedText = newValue
        }
    }
    
    var textFieldText: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var placeholder: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }
    
    var value: String? {
        get {
            valueLabel.text
        }
        set {
            valueLabel.text = newValue
        }
    }
    
    var valueAttr: NSAttributedString? {
        get {
            valueLabel.attributedText
        }
        set {
            valueLabel.attributedText = newValue
        }
    }
}

/**
   +--------------------------leadStackView -----------+   -------- trailStackView  —————— ——————+
   +  【iconImageView】   【stackView1】      |         【valueLabel】【annexButton  】 ——    +
   +
 
 
 
 */
public class MultiRowView: UIControl {
    public private(set) lazy var iconImageView: UIImageView  = {
        let imageView = UIImageView()
        leadStackView.insertArrangedSubview(imageView, at: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = MultiRowConfiguration.default().titleFont
        label.textColor = MultiRowConfiguration.default().titleColor
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        stackView1.addArrangedSubview(label)
        return label
    }()
    
    public private(set) lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = MultiRowConfiguration.default().detailsFont
        label.textColor = MultiRowConfiguration.default().detailsColor
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView1.addArrangedSubview(label)
        return label
    }()
    
    public private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = MultiRowConfiguration.default().textFieldFont
        textField.textColor = MultiRowConfiguration.default().textFieldColor
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackView1.addArrangedSubview(textField)
        
        let widthLC = textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        widthLC.priority = .defaultHigh
        widthLC.isActive = true
        return textField
    }()
    
    // 当前只处理了，跟在title后的情况
    private var tvLcH: NSLayoutConstraint!
    public private(set) lazy var textView: JKPlaceHolderTextView = {
        let textView = JKPlaceHolderTextView()
        textView.font = MultiRowConfiguration.default().textViewFont
        textView.textColor = MultiRowConfiguration.default().textViewColor
        textView.placeHolderColor = .placeholderText
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        textView.placeholderOrigin = CGPoint(x: 5, y: 2)
        stackView1.addArrangedSubview(textView)
        stackView1.set(distribution: .fill)
        stackView1.set(alignment: .top)
        tvLcH = textView.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([
            tvLcH,
            leadStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
        ])
        textView.delegate = self
        return textView
    }()
    
    public private(set) lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = MultiRowConfiguration.default().valueFont
        label.textColor = MultiRowConfiguration.default().valueColor
        label.textAlignment = .right
        label.isHidden(true)
        return label
    }()
    
    public private(set) lazy var annexButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(MultiRowConfiguration.default().themeColor, for: .normal)
        button.titleLabel?.font = MultiRowConfiguration.default().detailsFont
        button.isUserInteractionEnabled = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden(true)
        return button
    }()
    
    /// 问号按钮
    public private(set) lazy var questionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(MultiRowConfiguration.default().questionMarkImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        return button
    }()
    
    // MARK: - content stackView
    /// 【iconImageView】+  stackView1
    public lazy var leadStackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        return stackView
    }()
    
    /// valueLabel + annexButton
    public lazy var trailStackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [valueLabel, annexButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        return stackView
    }()
    
    /// titleLabel + detailsLabel / textField / textView
    public lazy var stackView1: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        leadStackView.addArrangedSubview(stackView)
        
        // 居中显示，（有些问题，需要调整）
        titleCenterY_lc = stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        titleCenterY_lc?.isActive = true
        return stackView
    }()
    
    private var titleCenterY_lc: NSLayoutConstraint?
    
    public override var isSelected: Bool {
        didSet {
            annexButton.isSelected = isSelected
        }
    }
    
    var insets = MultiRowConfiguration.default().insets {
        didSet {
            updateLayoutContentViews()
        }
    }
    
    public init(insets: UIEdgeInsets = MultiRowConfiguration.default().insets) {
        self.insets = insets
        super.init(frame: .zero)
        makeUI()
    }
    
    public convenience init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.init(insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    public convenience init(insetsX: CGFloat, insetsY: CGFloat) {
        self.init(insets: UIEdgeInsets(top: insetsY, left: insetsX, bottom: insetsY, right: insetsX))
    }
    
    public convenience init<T: MultiRowEntityable>(entity: T) {
        if let insets = entity.insets {
            self.init(insets: insets)
        } else {
            self.init()
        }
        if let icon = entity.icon {
            self.icon(icon)
        }
        
        if let title = entity.title {
            self.title(title)
        }
        
        if let details = entity.details {
            self.details(details)
        }
        
        if let value = entity.value {
            self.value(value)
        }
        
        if let placeholder = entity.placeholder {
            self.placeholder(placeholder)
        }
        
        self.trailerType(entity.trailerType)
        
        if let height = entity.height {
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: height)
            ])
        }
    }
    
    private var trailStackViewCenterY_lc: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        updateLayoutContentViews()
    }
    
    func updateLayoutContentViews() {
        NSLayoutConstraint.activate([
            leadStackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            leadStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            leadStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -insets.right),
            leadStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
        
        // 默认垂直居中
        trailStackViewCenterY_lc = trailStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let lc = trailStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadStackView.trailingAnchor, constant: 5)
        lc.priority = .defaultHigh
        NSLayoutConstraint.activate([
            trailStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            lc,
            trailStackViewCenterY_lc!
        ])
    }
    /*
    // 标记触摸开始的位置
    public var touchInside2 = false
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchInside2 = true
        // 可选：高亮效果
        isHighlighted = true
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        // 检查手指是否仍在按钮范围内
        touchInside2 = bounds.contains(touch.location(in: self))
        isHighlighted = touchInside2 // 更新高亮状态
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        // 如果手指在按钮内抬起，则触发事件
        if touchInside2 {
            sendActions(for: .touchUpInside)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
        touchInside2 = false
    }
     */
}

public extension MultiRowView {
    @discardableResult
    func icon(size: CGSize) -> Self {
        NSLayoutConstraint.deactivate(iconImageView.constraints)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: size.width),
            iconImageView.heightAnchor.constraint(equalToConstant: size.height)
        ])
        return self
    }
    
    @discardableResult
    func icon(_ image: UIImage?, resize: CGSize? = nil) -> Self {
        iconImageView.image(image)
        let size = resize ?? (image?.size ?? .zero)
        return icon(size: size)
    }
    
    @discardableResult
    func icon(_ imageNamed: String?, resize: CGSize? = nil) -> Self {
        guard let imageNamed = imageNamed else { return self }
        guard let image = UIImage(named: imageNamed) else { return self }
        iconImageView.image(imageNamed)
        return icon(image, resize: resize)
    }
    // MARK: - titleLabel
    @discardableResult
    func titleWidth(_ width: CGFloat) -> Self {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: width),
        ])
        return self
    }
    
    @discardableResult
    func title(_ title: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        titleLabel.text = title
        return self.title(font: font, color: color)
    }
    
    @discardableResult
    func title(font: UIFont? = nil, color: UIColor? = nil) -> Self {
        if let font = font {
            titleLabel.font = font
        }
        
        if let color = color {
            titleLabel.textColor = color
        }
        return self
    }
    
    @discardableResult
    func titleSpecificText(_ text: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        if let font = font {
            titleLabel.jk.setsetSpecificTextFont(text, font: font)
        }
        
        if let color = color {
            titleLabel.jk.setSpecificTextColor(text, color: color)
        }
        return self
    }
    
    // MARK: - detailsLabel
    @discardableResult
    func details(_ title: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        detailsLabel.text = title
        return self.details(font: font, color: color)
    }
    
    @discardableResult
    func details(font: UIFont? = nil, color: UIColor? = nil) -> Self {
        if let font = font {
            detailsLabel.font = font
        }
        
        if let color = color {
            detailsLabel.textColor = color
        }
        return self
    }
    
    func detailsLine(_ line: Int) -> Self {
        detailsLabel.numberOfLines = line
        return self
    }
    
    // MARK: - valueLabel
    @discardableResult
    func value(_ title: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        valueLabel.text = title
        return self.value(font: font, color: color)
    }
    
    @discardableResult
    func value(font: UIFont? = nil, color: UIColor? = nil) -> Self {
        if let font = font {
            valueLabel.font = font
        }
        
        if let color = color {
            valueLabel.textColor = color
        }
        valueLabel.isHidden(false)
        return self
    }
    
    // MARK: - textField
    @discardableResult
    func placeholder(_ placeholder: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        textField.placeholder = placeholder
        return self.TF(font: font, color: color)
    }
    
    @discardableResult
    func TF(font: UIFont? = nil, color: UIColor? = nil) -> Self {
        if let font = font {
            textField.font = font
        }
        if let color = color {
            textField.textColor = color
        }
        return self
    }
    
    // MARK: - textView
    @discardableResult
    func tvPlaceholder(_ placeholder: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        textView.placeHolder = placeholder
        return self.tv(font: font, color: color)
    }
    
    @discardableResult
    func tv(font: UIFont? = nil, color: UIColor? = nil) -> Self {
        if let font = font {
            textView.font = font
        }
        if let color = color {
            textView.textColor = color
        }
        return self
    }
    
    @discardableResult
    func leftStackAxis(_ axis: NSLayoutConstraint.Axis) -> Self {
        stackView1.axis = axis
        switch axis {
        case .horizontal:
            stackView1.alignment = .center
        case _:
            stackView1.alignment = .leading
        }
        return self
    }
    
    @discardableResult
    func leftStackSpacing(_ spacing: CGFloat) -> Self {
        stackView1.spacing = spacing
        return self
    }
    
    @discardableResult
    func leftStackAlignment(_ alignment: UIStackView.Alignment) -> Self {
        stackView1.alignment = alignment
        return self
    }
    
    @discardableResult
    func trailerType(_ trailerType: MultiTrailerType) -> Self {
        annexButton.isHidden = false
        switch trailerType {
        case .none:
            annexButton.isHidden = true
        case .password:
            textField.isSecureTextEntry = true
            annexButton.setImage(MultiRowConfiguration.default().eyeOffImage, for: .normal)
            annexButton.setImage(MultiRowConfiguration.default().eyeOnImage, for: .selected)
            annexButton.isUserInteractionEnabled = true
            annexButton.addTarget(self, action: #selector(tapEyeButton), for: .touchUpInside)
            
            if stackView1.axis == .vertical {
                // 按钮与textField居中对齐
                trailerVerAlign(.textField)
            }
            NSLayoutConstraint.activate([
                annexButton.widthAnchor.constraint(equalToConstant: 22)
            ])
        case .verificationCode:
            annexButton.setTitleColor(MultiRowConfiguration.default().themeColor, for: .normal)
            annexButton.setTitle("获取验证码", for: .normal)
            if stackView1.axis == .vertical {
                // 按钮与textField居中对齐
                trailerVerAlign(.textField)
            }
            NSLayoutConstraint.activate([
                annexButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
                annexButton.widthAnchor.constraint(lessThanOrEqualToConstant: 90)
            ])
        case .arrow:
            annexButton.setImage(MultiRowConfiguration.default().arrowImage, for: .normal)
            annexButton.setImage(MultiRowConfiguration.default().arrowImage, for: .selected)
            trailerSize(CGSize(width: 25, height: 25))
        case .switch:
            annexButton.setImage(MultiRowConfiguration.default().switchOffImage, for: .normal)
            annexButton.setImage(MultiRowConfiguration.default().switchOnImage, for: .selected)
        case .icon(let image):
            self.trailerType(.icon2(image, image))
        case let .icon2(image, image2):
            annexButton.setImage(image, for: .normal)
            annexButton.setImage(image2, for: .selected)
        }
        return self
    }
    
    @discardableResult
    func trailerType(icon: String? = nil, title: String? = nil) -> Self {
        annexButton.isHidden = false
        annexButton.setTitle(title, for: .normal)
        if let icon = icon {
            annexButton.setImage(.init(named: icon), for: .normal)
        } else {
            annexButton.setImage(nil, for: .normal)
        }
        return self
    }
    
    @discardableResult
    func trailerType(icon: String, selectIcon: String) -> Self {
        annexButton.isHidden = false
        annexButton.setImage(.init(named: icon), for: .normal)
        annexButton.setImage(.init(named: icon), for: .selected)
        return self
    }

    @discardableResult
    func trailerSize(_ size: CGSize) -> Self {
        annexButton.isHidden = false
        NSLayoutConstraint.activate([
           annexButton.widthAnchor.constraint(equalToConstant: size.width),
           annexButton.heightAnchor.constraint(equalToConstant: size.height)
        ])
        return self
    }
    
    @discardableResult
    func trailerVerAlign(_ align: TrailerVerAlign) -> Self {
        trailStackViewCenterY_lc?.isActive = false
        switch align {
        case .parent:
            trailStackViewCenterY_lc?.isActive = true
        case .title:
            trailStackView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        case .details:
            trailStackView.centerYAnchor.constraint(equalTo: detailsLabel.centerYAnchor).isActive = true
        case .textField:
            trailStackView.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        }
        return self
    }
    
    @discardableResult
    func deactivateTitleCenterY() -> Self {
        titleCenterY_lc?.isActive = false
        return self
    }
    
    /// 点击切换密码输入窗是否是密文
    @objc private func tapEyeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        textField.isSecureTextEntry = !sender.isSelected
    }
    
    @discardableResult
    func addQuestionMarkImage(follow view: UIView? = nil) -> Self {
        let followView = view ?? titleLabel
        NSLayoutConstraint.activate([
            questionButton.widthAnchor.constraint(equalToConstant: 16),
            questionButton.heightAnchor.constraint(equalToConstant: 16),
            followView.centerYAnchor.constraint(equalTo: questionButton.centerYAnchor),
            questionButton.leadingAnchor.constraint(equalTo: followView.trailingAnchor, constant: 8)
        ])
        return self
    }
}

extension MultiRowView: UITextViewDelegate {
    // 自动计算textView高度
    public func textViewDidChange(_ textView: UITextView) {
        let width = textView.frame.width - textView.textContainerInset.left - textView.textContainerInset.right
        // 有时会不对
        let textHeight = "\(textView.text ?? "呃")呃".jk.heightAccording(width: width, font: textView.font!) + textView.textContainerInset.top + textView.textContainerInset.bottom
        let autoHeight = max(textHeight, 30)
        guard tvLcH.constant != autoHeight else {
            return
        }
         tvLcH.constant = autoHeight
    }
}
