//
//  ViewController.swift
//  SwiftNest
//
//  Created by duanbhu on 06/03/2025.
//  Copyright (c) 2025 duanbhu. All rights reserved.
//

import UIKit
import SwiftNest
import SnapKit

@MainActor
extension MultiRowViewContainerable {
    
    @discardableResult
    func configRowViews(at entities: [RowEntity], spacing: CGFloat = 1, configBlock:((RowEntity, MultiRowView) -> ())? = nil) -> (UIStackView, [MultiRowView]) {
        let rowViews = rowViews(at: entities, configBlock: configBlock)
        let stackView = UIStackView(arrangedSubviews: rowViews)
            .set(spacing: spacing)
            .set(axis: .vertical)
            .backgroundColor(.black)
        
        if let vc = self as? ViewController {
            vc.containerView.addSubview(stackView)
            
            stackView.snp.makeConstraints { make in
                make.top.equalTo(16 + kSafeAreaTopHeight)
                make.leading.width.bottom.equalToSuperview()
            }
        }
        return (stackView, rowViews)
    }
}

enum CreateTemplateItemType: String {
    case name = "模板名称"
    case signature = "模板签名"
    case content = "模板内容"
    case deliveryTime = "取餐时间(必选）"
    case deliveryAddress = "取餐地址(必选）"
    case phone = "联系电话"
    case tips
    
    static var allCases: [CreateTemplateItemType] {
        return [.name, .signature, .content, .deliveryTime, .deliveryAddress, .phone, .tips]
    }
}

extension CreateTemplateItemType: MultiRowEntityable {
    var title: String? {
        switch self {
        case .tips: nil
        default: rawValue
        }
    }
    
    var placeholder: String? {
        switch self {
        case .name: "请输入模板名称"
        case .phone: "请输入手机号"
        default: nil
        }
    }
    
    var trailerType: MultiTrailerType {
        switch self {
        case .signature: .deepArrow
        case .deliveryTime: .icon(.init(named: "icon_arrow_down_black"))
        default: .none
        }
    }
}

class ViewController: UIViewController, MultiRowViewContainerable {
    typealias RowEntity = CreateTemplateItemType
    
    lazy var containerView: UIView  = {
        let imageView = UIView()
            .addTo(self.view)
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor(.gray)

        containerView.snp.makeConstraints { make in
            make.top.leading.width.equalToSuperview()
        }
        let tips = """
            提示：
              1. 通知中不得出现任何广告、诈骗、色情等和外卖无关的违法内容，否则一律封号并报警。余额次数不退。
              2. 计费标准：70字内按1条计费，超出70字按2条计费。
              3. 当订单有取餐码时，发送短信自动添加，订单无取餐码时，通知信息不显示取餐码。
            """
        
        configRowViews(at: RowEntity.allCases, spacing: 0) { item, rowView in
            rowView.backgroundColor(.white)
                .title(font: .semibold(16))
                .addSeparatorLine(color: .color("#EEEEEE"), inset: 16.wpt)
            
            switch item {
            case .signature:
                rowView.value("", font: .regular(14))
            case .deliveryTime:
                rowView.value("", font: .regular(14), color: .color("#F31804"))
            case .content:
                rowView.leftStackAxis(.vertical)
                    .detailsLine(0)
                    .leftStackSpacing(14.wpt)
                    .details("取餐码【取餐码】你的外卖【取餐时间】到【取餐地址】，请尽快取餐。【联系电话】。")
            case .tips:
                rowView.detailsLine(0)
                    .details(tips, font: .regular(14), color: .color("#798499"))
            case .deliveryAddress:
                rowView.tvPlaceholder("请输入取餐地址")
                    .limit(20, .textView)
            case .phone:
                rowView.icon("icon_delivery_search", resize: CGSize(width: 20.wpt, height: 20.wpt))
                rowView.trailerType(icon: "icon_arrow_down_black", title: "订单编号")
                    .trailerSize(CGSize(width: 95.wpt, height: 44))
                rowView.limit(.phoneNumber)
                
                rowView.annexButton.setImageTitleLayout(.imgRight, spacing: 2)
                    .textColor(.color("#798499"))
                rowView.layoutToTrailingView(true)
            default: break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MultiTrailerType {
    static var deepArrow: MultiTrailerType = .icon(UIImage(named: "icon_row_arrow_right_deep"))
}
