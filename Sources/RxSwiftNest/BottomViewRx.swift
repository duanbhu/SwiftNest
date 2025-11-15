//
//  BottomViewRx.swift
//  Pods
//
//  Created by Duanhu on 2025/10/10.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftNest

@MainActor
public extension Reactive where Base: BottomView {
    
    var selectAllTap: ControlEvent<Void> {
        return base.selectAllButton.rx.tap
    }
    
    func itemTap(at index: Int) -> ControlEvent<Void> {
        return base.menuItems[index].rx.tap
    }
    
    func itemTap(tag: Int) -> Driver<Void> {
        guard let button = base.menuItems.first(where: { button in button.tag == tag }) else { return .empty()}
        return button.rx.tap.asDriver()
    }
    
    func itemEnabled(at index: Int) -> Binder<Bool> {
        return Binder(self.base, binding: { (view, isEnabled) in
            view.menuItems[index].isEnabled = isEnabled
        })
    }
    
    func itemEnabled(tag: Int) -> Binder<Bool> {
        return Binder(self.base, binding: { (view, isEnabled) in
            guard let button = view.menuItems.first(where: { button in button.tag == tag }) else { return  }
            button.isEnabled = isEnabled
        })
    }
    
    func itemsIsEnabled() -> Binder<Bool> {
        return Binder(self.base, binding: { (view, isEnabled) in
            view.menuItems.forEach {
                $0.isEnabled = isEnabled
            }
        })
    }
}
