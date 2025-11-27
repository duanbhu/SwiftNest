//
//  File.swift
//  SwiftNest
//
//  Created by Duanhu on 2025/5/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SwiftNest

@MainActor
public extension Reactive where Base: MultiRowView {
    /// MultiRowView. tap
    func tap() -> Observable<Void> {
        return tapGesture().when(.recognized).map { _ in () }
    }
    
    func tapDriver() -> Driver<Void> {
        return tap()
            .asDriver { error in
                return .empty()
            }
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
    
    /// textView.rx.textInput
    var textInput2: TextInput<UITextView> {
        let textView = base.textView as UITextView
        return textView.rx.textInput
    }
    
    /// textField.rx.text.orEmpty.asDriver()
    var editText: Driver<String> {
        return base.textField.rx.text.orEmpty.asDriver()
    }
}
