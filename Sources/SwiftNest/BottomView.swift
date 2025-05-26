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
    
    var menuItems: [UIView] = []
    
    public init(height: CGFloat = 52.wpt) {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: height + kSafeAreaInsetBottom))
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
            safeAreaView.heightAnchor.constraint(equalToConstant: kSafeAreaInsetBottom),
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
    
    func stack(insets: UIEdgeInsets) -> Self {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets.left),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets.right),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets.bottom),
        ])
        return self
    }
    
    func stack(insetsX: CGFloat, insetsY: CGFloat) -> Self {
        return stack(insets: .init(top: insetsY, left: insetsX, bottom: insetsY, right: insetsX))
    }
    
    func stack(spacing: CGFloat, distribution: UIStackView.Distribution = .fillEqually) -> Self {
        stackView.spacing = spacing
        stackView.distribution = distribution
        return self
    }
    
    func addMenuItems(_ views: UIButton...) -> Self {
        views.forEach {
            stackView.addArrangedSubview($0)
        }
        return self
    }
}
