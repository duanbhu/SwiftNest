//
//  StringExt.swift
//  Takeaway
//
//  Created by Duanhu on 2024/1/25.
//

import Foundation
import JKSwiftExtension
import UIKit

public extension String {
    /// 手机号码分割 3 4 4
    /// - Parameters:
    ///   - sp: 分割符号
    ///   - isClear: 是否先把其中的非数字内容去掉
    /// - Returns: 格式后的手机号， 分机号统一分割成 188 8888 8888 转 8888
    func formatPhoneNumber(_ sp: Character = "-", isClear: Bool = true) -> String {
        if self.contains("*") {
            // 隐私号码不格式化
            return self
        }
        var phone = self
        if isClear {
            phone = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        }
        switch phone.count {
        case 4...7:
            phone.insert(sp, at: phone.index(phone.startIndex, offsetBy: 3))
        case 8...11:
            phone.insert(sp, at: phone.index(phone.startIndex, offsetBy: 7))
            phone.insert(sp, at: phone.index(phone.startIndex, offsetBy: 3))
        case 12...:
            phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 11))
            phone.insert("转", at: phone.index(phone.startIndex, offsetBy: 12))
            phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 13))
            phone.insert(sp, at: phone.index(phone.startIndex, offsetBy: 7))
            phone.insert(sp, at: phone.index(phone.startIndex, offsetBy: 3))
        default:
            break
        }
        return phone
    }
    
    /// 去掉手机号中的空格、或者-
    var cleanMobile: String {
        guard !contains("*") else { return self }
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

public extension String {
    /// 正则校验
    /// - Parameter rgex: 正则表达式
    /// - Returns: 是否匹配
    func predicateValue(rgex: String) -> Bool {
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", rgex)
        return checker.evaluate(with: (self))
    }
    
    /// 判断是否是有效的运单号
    var isWaybillNo: Bool {
        let rgex = "^(?!.*(Q|QQ|WX|VX|ZFB|ZHIFUBAO|WEIXIN))[A-Z0-9-]{9,24}$"
        return uppercased().predicateValue(rgex: rgex)
    }
    
    /// 判断是否是有效的手机号码
    var isPhoneNumber: Bool {
        let mobileRgex = "^1[3-9]\\d{9}$"
        return predicateValue(rgex: mobileRgex)
    }
    
    /// 手机号或者隐私号
    var isPhoneNumberOrSecretNo: Bool {
        return isPhoneNumber || isSecretMobile
    }
    
    /// 判断是否是隐私号
    var isSecretMobile: Bool {
        return predicateValue(rgex: "^1\\*{10}$") || predicateValue(rgex: "^1\\*{6,7}\\d{3,4}$") ||
        predicateValue(rgex: "^1\\d{2}\\*{4,5}\\d{3,4}$")
    }
    
    /// 虚拟号
    var isVirtualPhone: Bool {
        let mobileRgex = "^1[3-9]\\d{9}([\\s\\S]{0,2}\\d{3,4})?$"
        return predicateValue(rgex: mobileRgex)
    }
    
    /// 分机号
    var isExtNumber: Bool {
        let mobileRgex = "^\\d{3,4}"
        return predicateValue(rgex: mobileRgex)
    }
    
    /// 手机号验证码
    var isVerificationCode: Bool {
        let rgex = SwiftNest.defaultVerifyRgex.verificationCode
        return predicateValue(rgex: rgex)
    }
    
    /// 用户编号
    var isUsername: Bool {
        let rgex = SwiftNest.defaultVerifyRgex.username
        return predicateValue(rgex: rgex)
    }
    
    /// 密码
    var isPassword: Bool {
        let rgex = SwiftNest.defaultVerifyRgex.password
        guard rgex.isEmpty else { return predicateValue(rgex: rgex) }
        return self.count > 0
    }
    
    /// 身份证号码
    var isIdcard: Bool {
        let rgex = SwiftNest.defaultVerifyRgex.idcard
        return predicateValue(rgex: rgex)
    }
}
