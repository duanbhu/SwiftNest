//
//  MultiRowViewExt.swift
//  SwiftNest
//
//  Created by Duanhu on 2025/5/28.
//
import SwiftNest

public extension MultiRowView {
    enum TextInputViewType {
        case textField, textView
    }
    
    @discardableResult
    func limit(_ maxCount: Int, _ type: TextInputViewType = .textField) -> Self {
        switch type {
        case .textField:
            textField.limit(maxCount)
        case .textView:
            textView.limit(maxCount)
        }
        return self
    }
    
    @discardableResult
    func limit(_ maxCount: Int, allowedCharacters: String, _ type: TextInputViewType = .textField) -> Self {
        switch type {
        case .textField:
            textField.limit(maxCount, allowedCharacters: allowedCharacters)
        case .textView:
            textView.limit(maxCount, allowedCharacters: allowedCharacters)
        }
        return self
    }
    
    @discardableResult
    func limit(_ inputType: TextInputType) -> Self {
        textField.limit(inputType)
        return self
    }
}
