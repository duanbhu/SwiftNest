//
//  DHButton.swift
//  SwiftNest
//
//  Created by Duanhu on 2025/5/12.
//

import UIKit

class DHButton: UIButton {
    public enum ImagePosition {
        case left // 图片在左，文字在右
        case right // 图片在右，文字在左
        case top // 图片在上，文字在下
        case bottom // 图片在下，文字在上
    }
    
    var adjustImageSize: CGSize = .zero
    
    var adjustSpacing: CGFloat = 0
    
    var adjustPosition = ImagePosition.left
    
    var isNeedAdjust = false
    
    /// 还未实现
    var offset: CGPoint = .zero
    
    @discardableResult
    public func imagePosition(_ postion: ImagePosition, width: CGFloat? = 0, spacing: CGFloat, resize: CGSize = .zero) -> Self {
        adjustSpacing = spacing
        adjustPosition = postion
        adjustImageSize = resize
        if let width = width, resize == .zero {
            adjustImageSize = CGSize(width: width, height: width)
        }
        isNeedAdjust = true
        setNeedsLayout()
        return self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard isNeedAdjust else { return }
        if adjustSpacing <= 0 {
            adjustSpacing = 10
        }
        
        if adjustImageSize == .zero, let imageSize = imageView?.frame.size {
            adjustImageSize = imageSize
        }
        adjust()
    }
    
    private func adjust() {
        guard let titleLabel = titleLabel, let imageView = imageView else { return }
        let imageSize = self.adjustImageSize
        let labelSize = titleLabel.intrinsicContentSize
        
        var imageViewRect = CGRect(origin: .zero, size: imageSize)
        var labelRect = CGRect(origin: .zero, size: labelSize)

        let contentWidth = imageSize.width + labelSize.width + adjustSpacing
        let contentHeight = imageSize.height + labelSize.height + adjustSpacing

        switch adjustPosition {
        case .left:
            var minx = offset.x
            switch contentHorizontalAlignment {
            case .left, .leading:
                minx = offset.x
            case .center:
                minx = (bounds.size.width - contentWidth) / 2
            default:
                break
            }
        
            imageViewRect.origin.x = minx
            imageViewRect.origin.y = (bounds.size.height - imageSize.height) / 2
            
            labelRect.origin.x = imageViewRect.maxX + adjustSpacing
            labelRect.origin.y = (bounds.size.height - labelSize.height) / 2
        case .right:
            labelRect.origin.x = (bounds.size.width - contentWidth) / 2
            labelRect.origin.y = (bounds.size.height - labelSize.height) / 2

            imageViewRect.origin.x = labelRect.maxX + adjustSpacing
            imageViewRect.origin.y = (bounds.size.height - imageSize.height) / 2
        case .top:
            imageViewRect.origin.x = (bounds.size.width - imageViewRect.width) / 2
            imageViewRect.origin.y = (bounds.height - contentHeight) / 2
            
            labelRect.origin.x = (bounds.width - labelRect.width) / 2
            labelRect.origin.y = imageViewRect.maxY + adjustSpacing
        case .bottom:
            labelRect.origin.x = (bounds.width - labelRect.width) / 2
            labelRect.origin.y = (bounds.height - contentHeight) / 2
            
            imageViewRect.origin.x = (bounds.width - imageViewRect.width) / 2
            imageViewRect.origin.y = labelRect.maxY + adjustSpacing
        }
        imageView.frame = imageViewRect
        titleLabel.frame = labelRect
    }
}
