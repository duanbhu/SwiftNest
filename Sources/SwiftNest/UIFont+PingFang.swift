//
//  UIFont+PingFang.swift
//  FY-JetChat
//
//  Created by Jett on 2019/3/6.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

public extension UIFont {
    static func fitSize(_ fontSize: CGFloat) -> CGFloat {
        let realSize = (UIScreen.jk.width / 375.0) * fontSize
        return ceil(realSize)
    }
    
    /// 苹方-简 常规体 PingFangSC-Regular
    static func regular(_ size:CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: fitSize(size)) ?? UIFont.systemFont(ofSize:fitSize(size))
    }
    
    /// 苹方-简 中黑体 PingFangSC-Medium
    static func medium(_  size:CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fitSize(size)) ?? UIFont.systemFont(ofSize:fitSize(size))
    }
    
    /// 苹方-简 中粗体 PingFangSC-Semibold
    static func semibold(_ size:CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: fitSize(size)) ?? UIFont.systemFont(ofSize:fitSize(size))
    }
    
    /// 苹方-特粗体 PingFang-SC-Heavy
    static func heavy(_ size:CGFloat) -> UIFont {
        return UIFont(name: "PingFang-SC-Heavy", size: fitSize(size)) ?? UIFont.systemFont(ofSize:fitSize(size))
    }
}
