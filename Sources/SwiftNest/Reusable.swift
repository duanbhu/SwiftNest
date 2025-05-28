//
//  Reusable.swift
//  MobileExt
//
//  Created by Duanhu on 2024/3/21.
//

import class UIKit.UITableViewCell
import class UIKit.UITableViewHeaderFooterView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionReusableView
import class UIKit.UITableView
import class UIKit.UICollectionView
import Foundation

public protocol Reusable {
    static var reuseID: String {get}
}

public extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: Reusable{}

extension UITableViewCell: Reusable {}

extension UICollectionReusableView: Reusable{}

public extension UITableView {
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T>(ofType viewType: T.Type = T.self) -> T where T: UITableViewHeaderFooterView {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseID) as? T else {
            return viewType.init(reuseIdentifier: viewType.reuseID)
        }
        return view
    }
    
    @discardableResult
    func register<T>(cell cellType: T.Type = T.self) -> Self where T: UITableViewCell {
        register(cellType, forCellReuseIdentifier: cellType.reuseID)
        return self
    }
}

public extension UICollectionView {
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T>(ofKind kind: String, viewType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewType.reuseID, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
        
    @discardableResult
    func register<T>(cellType: T.Type = T.self) -> Self where T: UICollectionViewCell {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseID)
        return self
    }
    
    @discardableResult
    func register<T>(viewType: T.Type = T.self, of kind: String) -> Self where T: UICollectionReusableView {
        register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.reuseID)
        return self
    }
    
    @discardableResult
    func register<T: UICollectionViewCell>(cellTypes: [T.Type]) -> Self {
        cellTypes.forEach {
            register($0, forCellWithReuseIdentifier: $0.reuseID)
        }
        return self
    }
}
