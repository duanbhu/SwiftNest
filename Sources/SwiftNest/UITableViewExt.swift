//
//  UITableView+Ext.swift
//  Takeaway
//
//  Created by Duanhu on 2024/1/30.
//

import UIKit
import JKSwiftExtension

public extension UITableView {
    @discardableResult
    func headerHeight(_ h: CGFloat) -> Self {
        return tableHeaderView(UIView(frame: CGRect(x: 0, y: 0, width: jk.width, height: h)))
    }
    
    @discardableResult
    func footerHeight(_ h: CGFloat) -> Self {
        return tableFooterView(UIView(frame: CGRect(x: 0, y: 0, width: jk.width, height: h)))
    }
}
