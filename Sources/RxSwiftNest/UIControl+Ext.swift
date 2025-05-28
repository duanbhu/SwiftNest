//
//  UIControlExtension.swift
//  Posthouse_iOS
//
//  Created by Duanhu on 2023/8/22.
//

import UIKit
import RxSwift
import RxCocoa

@MainActor fileprivate var UIControlBackgroundColorsContext: UInt8 = 0

@MainActor fileprivate var UIControlBorderColorsContext: UInt8 = 0

public extension UIControl {
    private var backgroundColors: [UInt: UIColor] {
        get {
            return objc_getAssociatedObject(self, &UIControlBackgroundColorsContext) as? [UInt: UIColor] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &UIControlBackgroundColorsContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var borderColors: [UInt: UIColor] {
        get {
            return objc_getAssociatedObject(self, &UIControlBorderColorsContext) as? [UInt: UIColor] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &UIControlBorderColorsContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func updateBackgroundColor() {
        var currentState = UIControl.State.normal
        if state.contains(.selected) {
            currentState = .selected
        }
        
        if state.contains(.highlighted) {
            currentState = .highlighted
        }
        
        if state.contains(.disabled) {
            currentState = .disabled
        }
        
        if let color = backgroundColors[currentState.rawValue] {
            backgroundColor = color
        }
        
        if let color = borderColors[currentState.rawValue] {
            layer.borderColor(color)
        }
    }
    
    // MARK: - public
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        backgroundColors[state.rawValue] = color
        updateBackgroundColor()
        
        let isChanged = Observable.of(
            rx.observe(Bool.self, #keyPath(isSelected)),
            rx.observe(Bool.self, #keyPath(isHighlighted)),
            rx.observe(Bool.self, #keyPath(isEnabled))
        ).merge()
        
        isChanged
            .subscribe(onNext: { [weak self] _ in
                self?.updateBackgroundColor()
            })
            .disposed(by: rx.disposeBag)
    }
    
    @discardableResult
    func bgColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        setBackgroundColor(color, for: state)
        return self
    }
    
    @discardableResult
    func bgColor(_ hex: String, _ state: UIControl.State = .normal) -> Self {
        bgColor(.color(hex), state)
    }
    
    func setBorderColor(_ color: UIColor, for state: UIControl.State) {
        borderColors[state.rawValue] = color
        updateBackgroundColor()
        
        let isChanged = Observable.of(
            rx.observe(Bool.self, #keyPath(isSelected)),
            rx.observe(Bool.self, #keyPath(isHighlighted)),
            rx.observe(Bool.self, #keyPath(isEnabled))
        ).merge()
        
        isChanged
            .subscribe(onNext: { [weak self] _ in
                self?.updateBackgroundColor()
            })
            .disposed(by: rx.disposeBag)
    }
    
    @discardableResult
    func borderColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        setBorderColor(color, for: state)
        return self
    }
    
    @discardableResult
    func borderColor(_ hex: String, _ state: UIControl.State = .normal) -> Self {
        borderColor(.color(hex), state)
    }
}
