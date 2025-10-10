//
//  BottomView.swift
//  SwiftNest
//
//  Created by Duanhu on 2025/5/22.
//

import UIKit

public class BottomView: UIView {

    public private(set) var contentView = UIView()
    
    var safeAreaView = UIView()
    
    private lazy var stackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [])
            .set(spacing: 9)
            .set(distribution: .fillEqually)
        return stackView
    }()
    
    /// 全选按钮
    public private(set) lazy var selectAllButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_order_check_off"), for: .normal)
        button.setImage(UIImage(named: "icon_order_check_on"), for: .selected)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        return button
    }()
    
    public var isSelectAll: Bool {
        set {
            selectAllButton.isSelected = newValue
        }
        
        get {
            selectAllButton.isSelected
        }
    }
    
    /// 只有大于0时生效
    private var itemWidth: CGFloat = -1
    
    private let insetBottom: CGFloat
    
    public var menuItems: [UIButton] = []
    
    public init(height: CGFloat = 52.wpt, insetBottom: CGFloat? = nil) {
        let inset = insetBottom ?? kSafeAreaInsetBottom
        self.insetBottom = inset
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: height + inset))
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        backgroundColor(.white)
        
        layer.corner(8.wpt)
            .shadowColor(.color("000000", alpha: 0.1))
            .shadowOffset(.init(width: 0, height: -1))
            .shadowOpacity(1)
            .shadowRadius(4)
        layer.masksToBounds = false
        
        safeAreaView.backgroundColor = .white
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(safeAreaView)
        addSubview(contentView)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            safeAreaView.heightAnchor.constraint(equalToConstant: insetBottom),
            safeAreaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: bottomAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaView.topAnchor)
        ])
    }
}

public extension BottomView {
    @discardableResult
    func add(in superview: UIView) -> Self {
        superview.addSubview(self)
        let height = self.jk.height
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            heightAnchor.constraint(equalToConstant: height)
        ])
        return self
    }
    
    @discardableResult
    func stack(insets: UIEdgeInsets) -> Self {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets.left),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets.right),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets.bottom),
        ])
        return self
    }
    
    @discardableResult
    func stack(insetsX: CGFloat, insetsY: CGFloat) -> Self {
        return stack(insets: .init(top: insetsY, left: insetsX, bottom: insetsY, right: insetsX))
    }
    
    @discardableResult
    func stack(right: CGFloat, insetsY: CGFloat, itemWidth: CGFloat = -1) -> Self {
        self.itemWidth = itemWidth
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insetsY),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -right),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insetsY),
        ])
        return self
    }
    
    @discardableResult
    func stack(spacing: CGFloat, distribution: UIStackView.Distribution = .fillEqually) -> Self {
        stackView.spacing = spacing
        stackView.distribution = distribution
        return self
    }
    
    @discardableResult
    func addMenuItems(_ views: [UIButton]) -> Self {
        menuItems = views
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            if itemWidth > 0 {
                NSLayoutConstraint.activate([
                    view.widthAnchor.constraint(equalToConstant: itemWidth)
                ])
            }
            stackView.addArrangedSubview(view)
        }
        return self
    }
    
    @discardableResult
    func addMenuItems(_ views: UIButton...) -> Self {
        return addMenuItems(views)
    }
}
