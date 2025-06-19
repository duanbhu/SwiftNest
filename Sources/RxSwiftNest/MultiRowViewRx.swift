//
//  File.swift
//  SwiftNest
//
//  Created by Duanhu on 2025/5/19.
//

import UIKit
import RxSwift
import RxCocoa
#if !COCOAPODS
import SwiftNest
#endif

@MainActor
public extension Reactive where Base: MultiRowView {
    /// MultiRowView. tap
    var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
    
    /// annexButton.rx.tap
    var buttonTap: ControlEvent<Void> {
        base.annexButton.isUserInteractionEnabled(true)
        return base.annexButton.rx.tap
    }
    
    /// textField.rx.textInput
    var textInput: TextInput<UITextField> {
        return base.textField.rx.textInput
    }
    
    /// textField.rx.text.orEmpty.asDriver()
    var editText: Driver<String> {
        return base.textField.rx.text.orEmpty.asDriver()
    }
}
