//
//  UIView+Ext.swift
//  Takeaway
//
//  Created by Duanhu on 2024/1/23.
//

import UIKit

public extension UIView {
    enum RoundCorners {
        
        /** *None* of the corners will be round */
        case none
        
        /** *All* of the corners will be round */
        case all(radius: CGFloat)
        
        /** Only the *top* left and right corners will be round */
        case top(radius: CGFloat)
        
        /** Only the *bottom* left and right corners will be round */
        case bottom(radius: CGFloat)
        
        case left(radius: CGFloat)
        
        case right(radius: CGFloat)
    }
    
    @discardableResult
    func roundCorners(_ corners: RoundCorners) -> Self {
        switch corners {
        case .none:
            layer.maskedCorners = []
        case .all(radius: let radius):
            corner(radius)
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .top(radius: let radius):
            corner(radius)
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom(radius: let radius):
            corner(radius)
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .left(radius: let radius):
            corner(radius)
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .right(radius: let radius):
            corner(radius)
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        return self
    }
    
    @discardableResult
    func corner(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func borderWidth(_ w: CGFloat) -> Self {
        layer.borderWidth = w
        return self
    }
    
    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    func borderColor(_ hex: String) -> Self {
        return borderColor(.color(hex))
    }
    
    @discardableResult
    func masksToBounds(_ mask: Bool) -> Self {
        layer.masksToBounds = mask
        return self
    }
    
    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        layer.shadowColor = color.cgColor
        return self
    }
    
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        layer.shadowOpacity = opacity
        return self
    }
    
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        layer.shadowRadius = radius
        return self
    }
    
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        layer.shadowOffset = offset
        return self
    }
    
    @discardableResult
    func shadowOffset(w: CGFloat, h: CGFloat) -> Self {
        layer.shadowOffset = CGSize(width: w, height: h)
        return self
    }
    
    @discardableResult
    func shadow(radius: CGFloat = 6.wpt) -> Self {
        return corner(radius)
            .shadowColor(.black)
            .shadowOpacity(0.05)
            .shadowRadius(2)
            .shadowOffset(w: 0, h: 1)
            .masksToBounds(false)
    }
}

public extension Array {
    @MainActor
    func corner(_ radius: CGFloat) {
        guard let array = self as? [UIView] else { return  }
        
        guard let f = array.first else { return }
        f.roundCorners(.top(radius: radius))
        
        guard let l = array.last else { return }
        l.roundCorners(.bottom(radius: radius))
    }
    
    @MainActor
    func cornerHor(_ radius: CGFloat) {
        guard let array = self as? [UIView] else { return  }
        
        guard let f = array.first else { return }
        f.roundCorners(.left(radius: radius))
        
        guard let l = array.last else { return }
        l.roundCorners(.right(radius: radius))
    }
}


// 分割线
public extension UIView {
    @discardableResult
    func addSeparatorLine(color: UIColor = .color("#F0F0F0", alpha: 0.8), height: CGFloat = 1, left: CGFloat = 0, right: CGFloat = 0) -> Self {
        guard viewWithTag(4263782) == nil else { return self }
        
        let separatorLine = UIView()
        separatorLine.tag = 4263782
        separatorLine.backgroundColor = color
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -right),
            separatorLine.heightAnchor.constraint(equalToConstant: height)
        ])
        return self
    }
    
    @discardableResult
    func addSeparatorLine(color: UIColor = .color("#F0F0F0", alpha: 0.8), height: CGFloat = 1, inset: CGFloat) -> Self {
        addSeparatorLine(color: color, height: height, left: inset, right: inset)
    }
}

public extension Int {
    var hpt: CGFloat {
        CGFloat(self).wpt
    }
    
    var wpt: CGFloat {
        CGFloat(self).wpt
    }
}

public extension CGFloat {
    var hpt: CGFloat {
        return kFitScale(at: self)
    }
    
    var wpt: CGFloat {
        return kFitScale(at: self)
    }
}
