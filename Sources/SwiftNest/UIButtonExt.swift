//
//  UIButton+Ext.swift
//  Takeaway
//
//  Created by Duanhu on 2024/3/2.
//

import JKSwiftExtension
import UIKit

public extension UIButton {
    /// 图片 和 title 的布局样式
    enum ButtonStyle {
        case imgTop
        case imgBottom
        case imgLeft
        case imgRight
    }
    
    @discardableResult
    func setImageTitleLayout(_ layout: ButtonStyle, spacing: CGFloat = 0) -> Self {
        switch layout {
        case .imgTop:
            jk.setImageTitleLayout(.imgTop, spacing: spacing)
        case .imgBottom:
            jk.setImageTitleLayout(.imgBottom, spacing: spacing)
        case .imgLeft:
            jk.setImageTitleLayout(.imgLeft, spacing: spacing)
        case .imgRight:
            jk.setImageTitleLayout(.imgRight, spacing: spacing)
        }
        titleLabel?.adjustsFontSizeToFitWidth = true
        return self
    }
    
    @discardableResult
    func titleEdgeInsets(_ edgeInsets: UIEdgeInsets) -> Self {
        self.titleEdgeInsets = edgeInsets
        return self
    }
}
