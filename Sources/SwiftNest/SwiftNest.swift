// The Swift Programming Language
// https://docs.swift.org/swift-book

import JKSwiftExtension
import UIKit

// MARK: - 常用距离
@MainActor
public let kScreenBounds = UIScreen.main.bounds

public let kScreenWidth = UIScreen.jk.width

public let kScreenHeight = UIScreen.jk.height

// MARK: - 屏幕适配375 | 6s尺寸
func kFitScale(at ratio: CGFloat) -> CGFloat {
    return (UIScreen.jk.width / 375) * ratio
}

func kFitSize(w: CGFloat, h: CGFloat) -> CGSize {
    return CGSize(width: kFitScale(at: w), height: kFitScale(at: h))
}

@MainActor
public let kSafeAreaInsets = { () -> UIEdgeInsets in
    var insets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    if #available(iOS 13.0, *) {
        let keyWindow = UIApplication.shared.connectedScenes
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows.first
        insets = keyWindow?.safeAreaInsets ?? insets
    } else {
        insets = UIApplication.shared.keyWindow?.safeAreaInsets ?? insets
    }
    return insets
}

@MainActor public let isIphoneX = { () -> Bool in
    return kSafeAreaInsets().bottom > 0
}

/// 安全区底部高度
public let kSafeAreaInsetBottom = kSafeAreaInsets().bottom

/// 状态栏高度
public let kStatusBarHeight = kSafeAreaInsets().top

/// 导航栏高度
public let kNavHeight = 44.0

/// 导航栏+状态栏高度
public let kSafeAreaTopHeight = kNavHeight + kStatusBarHeight

/// TabBar高度
public let kTabBarH = 49.0

/// TabBar+安全区高度
public let kTabBarHeight = kTabBarH + kStatusBarHeight
