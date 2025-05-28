//
//  UIImageView+Ext.swift
//  Takeaway
//
//  Created by Duanhu on 2024/1/23.
//

import UIKit

public extension UIImageView {
    var multiplied: CGFloat {
        var multipliedBy: CGFloat = 1.0
        if let imageSize = image?.size {
            multipliedBy = imageSize.height / imageSize.width
        }
        return multipliedBy
    }
    
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    func image(_ named: String?) -> Self {
        guard let named = named else { return self }
        self.image = UIImage(named: named)
        return self
    }
}
