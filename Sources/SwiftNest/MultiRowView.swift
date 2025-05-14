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
    
    var themeColor: UIColor = .black
    
    var titleColor: UIColor = .black
    var titleFont: UIFont = .medium(16)
    
    var detailsColor: UIColor = .black
    var detailsFont: UIFont = .regular(14)
    
//    var placeholderColor: UIColor = .placeholderText
    var textFieldColor: UIColor = .black
    var textFieldFont: UIFont = .regular(14)
    
    var valueColor: UIColor = .gray
    var valueFont: UIFont = .regular(14)
    
    var arrowImage = UIImage(named: "icon_row_arrow_right_black")
    
    var switchOnImage = UIImage(named: "icon_row_switch_on")
    
    var switchOffImage = UIImage(named: "icon_row_switch_off")
}

public extension MultiRowView {
    enum TrailerType {
        case none
        case password // 密码输入框
        case verificationCode  // 获取验证码
        case arrow
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
 「 -------------------------------------------------------------------contentStackView ---------------------------------------------------------------------------------------------|
             
     【iconImageView】 【 stackView1  [titleLabel] [detailsLabel] [textField] 】 【 stackView2  [valueLabel] [annexButton]】
 
  ------------------------------------------------------------------------------------——————---------- 』
 */
public class MultiRowView: UIControl {
    private(set) lazy var iconImageView: UIImageView  = {
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
    
    private(set) lazy var textField: UITextField = {
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
    
    private(set) lazy var annexButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.isUserInteractionEnabled = false
        stackView2.addArrangedSubview(button)
        return button
    }()
    
    // MARK: - content stackView
    // iconImageView + 【stackView1】
    private lazy var contentStackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
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
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        contentStackView.addArrangedSubview(stackView)
        return stackView
    }()
    
    var insets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16) {
        didSet {
            updateLayoutContentViews()
        }
    }
    
    public init() {
        super.init(frame: .zero)
        makeUI()
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
    func icon(_ image: UIImage?, resize: CGSize? = nil) -> Self {
        iconImageView.image(image)
        
        let size = resize ?? (image?.size ?? .zero)
        NSLayoutConstraint.deactivate(iconImageView.constraints)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: size.width),
            iconImageView.heightAnchor.constraint(equalToConstant: size.height)
        ])
        return self
    }
    
    @discardableResult
    func icon(_ imageNamed: String?, resize: CGSize? = nil) -> Self {
        guard let imageNamed = imageNamed else { return self }
        guard let image = UIImage(named: imageNamed) else { return self }
        iconImageView.image(imageNamed)
        return icon(image, resize: resize)
    }
    
    @discardableResult
    func title(_ title: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        titleLabel.text = title
        
        if let font = font {
            titleLabel.font = font
        }
        
        if let color = color {
            titleLabel.textColor = color
        }
        return self
    }
    
    @discardableResult
    func details(_ title: String, font: UIFont? = nil, color: UIColor? = nil) -> Self {
        detailsLabel.text = title
        
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
        
        if let font = font {
            textField.font = font
        }
        
        if let color = color {
            textField.textColor = color
        }
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
        switch trailerType {
        case .none:
            annexButton.isHidden = true
        case .password:
            textField.isSecureTextEntry = true
            break
        case .verificationCode:
            annexButton.setTitleColor(MultiRowConfiguration.default().themeColor, for: .normal)
            annexButton.setTitle("获取验证码", for: .normal)
        case .arrow:
            annexButton.setImage(MultiRowConfiguration.default().arrowImage, for: .normal)
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
}
