//
//  UITextField+Ext.swift
//  Takeaway
//
//  Created by Duanhu on 2024/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

public enum TextInputType {
    case password, verificationCode, phoneNumber, username
}

public extension String {
    /// 数字、字母和杠
    static let digitAndLetters_ = "abcdefghijklmnoprstuvwxyzABCDEFGHIJKLMNOPRSTUVWXYZ0123456789-"
}

public extension UITextField {
    @discardableResult
    func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        clearButtonMode = mode
        return self
    }
    
    @discardableResult
    /// 限制输入字数
    /// - Parameter maxCount: 最大字数
    /// - Returns: self
    func limit(_ maxCount: Int) -> Self {
        rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.markedTextRange == nil, text.count > maxCount {
                self.text = String(text.prefix(maxCount))
            }
        }).disposed(by: rx.disposeBag)
        return self
    }
    
    @discardableResult
    func limit(_ maxCount: Int, allowedCharacters: String) -> Self {
        rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.markedTextRange == nil {
                let set = CharacterSet(charactersIn: allowedCharacters)
                var string = text.components(separatedBy: set.inverted).joined()
                
                let pattern = "(?i)zfb|wx|vx|q" // (?i) 表示忽略大小写
                let regex = try? NSRegularExpression(pattern: pattern, options: [])
                let range = NSRange(location: 0, length: string.utf16.count)
                string = regex?.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "") ?? string
                
                if string.count > maxCount {
                    string = String(string.prefix(maxCount))
                }
                self.text = string
            }
        }).disposed(by: rx.disposeBag)
        return self
    }
    
    /// 输入时，自动格式化手机
    @discardableResult
    func formatPhoneNumber(_ sp: Character = "-") -> Self {
        keyboardType(.phonePad)
        rx.text.orEmpty.asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                var phoneNumber = String(text)
                let maxCount = 13
                if self.markedTextRange == nil, text.count > maxCount {
                    phoneNumber = String(text.prefix(maxCount))
                }
                self.text = phoneNumber.formatPhoneNumber(sp)
            })
            .disposed(by: rx.disposeBag)
        return self
    }
    
    @discardableResult
    func limit(_ inputType: TextInputType) -> Self {
        switch inputType {
        case .phoneNumber:
            formatPhoneNumber(" ")
        case .verificationCode:
            limit(6).keyboardType(.numberPad)
        case .password:
            limit(15).keyboardType(.asciiCapable)
            isSecureTextEntry = true
        default:
            break
        }
        return self
    }
}

public extension UITextView {
   
    @discardableResult
    /// 限制输入字数
    /// - Parameter maxCount: 最大字数
    /// - Returns: self
    func limit(_ maxCount: Int) -> Self {
        rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.markedTextRange == nil, text.count > maxCount {
                self.text = String(text.prefix(maxCount))
            }
        }).disposed(by: rx.disposeBag)
        return self
    }
    
    @discardableResult
    func limit(_ maxCount: Int, allowedCharacters: String) -> Self {
        rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.markedTextRange == nil {
                let set = CharacterSet(charactersIn: allowedCharacters)
                var string = text.components(separatedBy: set.inverted).joined()
                
                let pattern = "(?i)zfb|wx|vx|q" // (?i) 表示忽略大小写
                let regex = try? NSRegularExpression(pattern: pattern, options: [])
                let range = NSRange(location: 0, length: string.utf16.count)
                string = regex?.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "") ?? string
                
                if string.count > maxCount {
                    string = String(string.prefix(maxCount))
                }
                self.text = string
            }
        }).disposed(by: rx.disposeBag)
        return self
    }
}
