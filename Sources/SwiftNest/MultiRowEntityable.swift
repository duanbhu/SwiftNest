//
//  MultiRowEntityable.swift
//  TakeawayDelivery
//
//  Created by Duanhu on 2025/5/14.
//

import Foundation

/// 创建MultiRowView时，对应的实体类。
public protocol MultiRowEntityable: Equatable, Hashable {
    
    var icon: String? { get }
    
    var title: String? { get }
    
    var details: String? { get }
    
    var value: String? { get }
        
    var placeholder: String? { get }
    
    var trailerType: MultiRowView.TrailerType { get }
    
    var height: CGFloat? { get }
}

public extension MultiRowEntityable {
    
    var icon: String? { nil }
    
    var title: String? { nil }
    
    var details: String? { nil }
    
    var value: String? { nil }
        
    var placeholder: String? { nil }
    
    var trailerType: MultiRowView.TrailerType { .none }
    
    var height: CGFloat? { nil }
}

public protocol MultiRowViewContainerable {
    associatedtype RowEntity: MultiRowEntityable
    
    /// [RowEntity: MultiRowView], 数据字典，用来读取
    var rowViewDict: [RowEntity: MultiRowView] { get set }
}

@MainActor fileprivate var MultiRowDictKey: UInt8 = 0

@MainActor
public extension MultiRowViewContainerable {
    var rowViewDict: [RowEntity: MultiRowView] {
        get {
            if let dict = objc_getAssociatedObject(self, &MultiRowDictKey) as? [RowEntity: MultiRowView] {
                return dict
            } else {
                let dict: [RowEntity: MultiRowView] = [:]
                objc_setAssociatedObject(self, &MultiRowDictKey, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return dict
            }
        }
        set {
            objc_setAssociatedObject(
                self, 
                &MultiRowDictKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
 
public extension MultiRowViewContainerable {
    /// 根据MultiRowEntityable列表，创建MultiRowView
    /// - Parameters:
    ///   - entities: 实体列表
    ///   - configBlock: 自定义回调
    /// - Returns: MultiRowView List
    @MainActor func rowViews(at entities: [RowEntity], configBlock:((RowEntity, MultiRowView) -> ())? = nil) -> [MultiRowView] {
        var mutaSelf = self
        var rowViews: [MultiRowView] = []
        for entity in entities {
            let rowView = MultiRowView(entity: entity)
            configBlock?(entity, rowView)
            mutaSelf.rowViewDict[entity] = rowView
            rowViews.append(rowView)
        }
        return rowViews
    }
    
    /// 根据entity获取对应的MultiRowView
    func rowView(_ entity: RowEntity) -> MultiRowView {
        guard let rowView = rowViewDict[entity] else {
            fatalError("TextRowView is not fond for entity")
        }
        return rowView
    }
}
