//
//  MultiRowViewExt.swift
//  SwiftNest
//
//  Created by Duanhu on 2025/5/28.
//
#if !COCOAPODS
import SwiftNest
#endif

public extension MultiRowView {
    @discardableResult
    func limit(_ maxCount: Int) -> Self {
        textField.limit(maxCount)
        return self
    }
    
    @discardableResult
    func limit(_ maxCount: Int, allowedCharacters: String) -> Self {
        textField.limit(maxCount, allowedCharacters: allowedCharacters)
        return self
    }
    
    @discardableResult
    func limit(_ inputType: TextInputType) -> Self {
        textField.limit(inputType)
        return self
    }
}
