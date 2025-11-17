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
public func kSafeAreaInsets() -> UIEdgeInsets {
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
@MainActor
public var kSafeAreaInsetBottom: CGFloat {
    return kSafeAreaInsets().bottom
}

/// 状态栏高度
@MainActor
public var kStatusBarHeight: CGFloat {
    return kSafeAreaInsets().top
}

/// 导航栏高度
public let kNavHeight = 44.0

/// 导航栏+状态栏高度
@MainActor
public var kSafeAreaTopHeight: CGFloat {
    return kNavHeight + kStatusBarHeight
}

/// TabBar高度
public let kTabBarH = 49.0

/// TabBar+安全区高度
@MainActor
public var kTabBarHeight: CGFloat {
    return kTabBarH + kSafeAreaInsetBottom
}

//value 是AnyObject类型是因为有可能所传的值不是String类型，有可能是其他任意的类型。
public func kStringIsEmpty(_ value: String?) -> Bool {
    //首先判断是否为nil
    if (nil == value) {
        //对象是nil，直接认为是空串
        return true
    } else {
        //然后是否可以转化为String
        guard let value = value else {
            return true
        }
        return value == "" || value == "(null)" || 0 == value.count || value.isEmpty
    }
}

public func kStringEmpty(_ value: String?, to s: String) -> String {
    kStringIsEmpty(value) ? s : value!
}

public struct SwiftNest {

    private init() { }

    public nonisolated(unsafe) static var defaultVerifyRgex = VerifyRgex()
}

public struct VerifyRgex: Codable {
     
    /// 用户编号的正则
    public var username = "^[\\da-zA-Z]{6,16}"
    
    /// 手机号验证码的正则
    public var verificationCode = "^[\\da-zA-Z]{4}"
        
    /// 身份证号码
    public var idcard = "^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$"
    
    /// 密码的正则： 6-16位的数字+英文字母，如果为空时，则isPassword仅判断是否为空
    public var password = "^[\\da-zA-Z]{6,16}"
}
