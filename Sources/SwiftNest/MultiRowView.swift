//
//  MultiRowView.swift
//  SwiftNest
//
//  Created by Duanhu on 2025/5/12.
//

import UIKit

@MainActor
public class MultiRowConfiguration: NSObject {
    
    private static var single = MultiRowConfiguration()
    
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
    
//    var placeholderColor: UIColor = .placeholderText
    public var textFieldColor: UIColor = .black
    public var textFieldFont: UIFont = .regular(14)
    
    public var valueColor: UIColor = .gray
    public var valueFont: UIFont = .regular(14)
    
    /// 黑色箭头
    public var arrowImage = UIImage(named: "icon_row_arrow_right_black")
    
    public var switchOnImage = UIImage(named: "icon_row_switch_on")
    
    public var switchOffImage = UIImage(named: "icon_row_switch_off")
    
    /// 输入密码时，开启/关闭密文的小眼睛
    public var eyeOffImage = UIImage(named: "icon_row_eye_off")
    
    /// 输入密码时，开启/关闭密文的小眼睛
    public var eyeOnImage = UIImage(named: "icon_row_eye_on")
}

public extension MultiRowView {
    enum TrailerType {
        case none
        case password // 密码输入框
        case verificationCode  // 获取验证码
        case arrow // 箭头
        case `switch`
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
}

/**
 |-------------------------------------------------------------------------------- contentStackView -------------------------------------------------------------------------------- |
 |                                                                                                                                                                                                                               |
 |                                                                                                                                                                                                                               |
 |       【iconImageView】 【 stackView1  [titleLabel] [detailsLabel] [textField] 】 【 stackView2  [valueLabel] [annexButton]】               |
 |                                                                                                                                                                                                                               |
 |                                                                                                                                                                                                                               |
 |-------------------------------------------------------------------------------- contentStackView -------------------------------------------------------------------------------- |
 */
public class MultiRowView: UIControl {
    public private(set) lazy var iconImageView: UIImageView  = {
        let imageView = UIImageView()
        contentStackView.insertArrangedSubview(imageView, at: 0)
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = MultiRowConfiguration.default().titleFont
        label.textColor = MultiRowConfiguration.default().titleColor
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        stackView1.addArrangedSubview(label)
        return label
    }()
    
    private(set) lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = MultiRowConfiguration.default().detailsFont
        label.textColor = MultiRowConfiguration.default().detailsColor
        label.numberOfLines = 0
        stackView1.addArrangedSubview(label)
        return label
    }()
    
    public private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = MultiRowConfiguration.default().textFieldFont
        textField.textColor = MultiRowConfiguration.default().textFieldColor
        textField.clearButtonMode = .whileEditing
        stackView1.addArrangedSubview(textField)
        return textField
    }()
    
    private(set) lazy var textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    private(set) lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = MultiRowConfiguration.default().valueFont
        label.textColor = MultiRowConfiguration.default().valueColor
        stackView2.addArrangedSubview(label)
        return label
    }()
    
    public private(set) lazy var annexButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(MultiRowConfiguration.default().themeColor, for: .normal)
        button.titleLabel?.font = MultiRowConfiguration.default().detailsFont
        button.isUserInteractionEnabled = false
        stackView2.addArrangedSubview(button)
        return button
    }()
    
    // MARK: - content stackView
    // iconImageView +【stackView1】+【stackView2】
    private lazy var contentStackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 4
        addSubview(stackView)
        return stackView
    }()
    
    /// titleLabel + detailsLabel / textField / textView
    private lazy var stackView1: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        contentStackView.addArrangedSubview(stackView)
        return stackView
    }()
    
    /// valueLabel + annexButton
    private lazy var stackView2: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 5
        contentStackView.addArrangedSubview(stackView)
        return stackView
    }()
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        updateLayoutContentViews()
    }
    
    func updateLayoutContentViews() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }
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
        return self
    }
    
    @discardableResult
    func placeholder(_ placeholder: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        textField.placeholder = placeholder
        return self.TF(font: font, color: color)
    }
    
    @discardableResult
    func TF(font: UIFont? = nil, color: UIColor? = nil) -> Self {
        textField.placeholder = placeholder
        return self
    }
    
    
    @discardableResult
    func leftStackAxis(_ axis: NSLayoutConstraint.Axis) -> Self {
        stackView1.axis = axis
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
    func trailerType(_ trailerType: TrailerType) -> Self {
        annexButton.isHidden = trailerType == .none
        switch trailerType {
        case .none: break
        case .password:
            textField.isSecureTextEntry = true
            annexButton.setImage(MultiRowConfiguration.default().eyeOffImage, for: .normal)
            annexButton.setImage(MultiRowConfiguration.default().eyeOnImage, for: .selected)
            annexButton.isUserInteractionEnabled = true
            annexButton.addTarget(self, action: #selector(tapEyeButton), for: .touchUpInside)
            
            if stackView1.axis == .vertical {
                // 按钮与textField居中对齐
                contentStackView.alignment = .lastBaseline
            }
            NSLayoutConstraint.activate([
                annexButton.widthAnchor.constraint(equalToConstant: 22)
            ])
        case .verificationCode:
            annexButton.setTitleColor(MultiRowConfiguration.default().themeColor, for: .normal)
            annexButton.setTitle("获取验证码", for: .normal)
            
            if stackView1.axis == .vertical {
                // 按钮与textField居中对齐
                contentStackView.alignment = .lastBaseline
                NSLayoutConstraint.activate([
                    textField.heightAnchor.constraint(equalTo: stackView2.heightAnchor)
                ])
            }
            NSLayoutConstraint.activate([
                annexButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
                annexButton.widthAnchor.constraint(lessThanOrEqualToConstant: 90)
            ])
        case .arrow:
            annexButton.setImage(MultiRowConfiguration.default().arrowImage, for: .normal)
            annexButton.setImage(MultiRowConfiguration.default().arrowImage, for: .selected)
        case .switch:
            annexButton.setImage(MultiRowConfiguration.default().switchOffImage, for: .normal)
            annexButton.setImage(MultiRowConfiguration.default().switchOnImage, for: .selected)
        }
        return self
    }
    
    @discardableResult
    func trailerType(icon: String? = nil, title: String? = nil) -> Self {
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
        annexButton.setImage(.init(named: icon), for: .normal)
        annexButton.setImage(.init(named: icon), for: .selected)
        return self
    }
    
    /// stackView2与Title水平对齐
    func centerYByTitle() {
        stackView2.removeFromSuperview()
        self.addSubview(stackView2)
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView2.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            stackView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        ])
    }
    
    /// 点击切换密码输入窗是否是密文
    @objc private func tapEyeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        textField.isSecureTextEntry = !sender.isSelected
    }
}
