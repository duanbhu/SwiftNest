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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor(.gray)
        let iconRowView = MultiRowView()
            .icon(size: CGSize(width: 55, height: 55))
            .trailerType(.arrow)
            .backgroundColor(.white)
    
        iconRowView.iconImageView.corner(27.5)
            .backgroundColor(.green)
        
        let subviews = (0...10).map { idx in
            let rowView = MultiRowView()
                .title("手机号")
                .backgroundColor(.white)
            switch idx {
            case 0:
                rowView.details("188 8888 8888")
                    .trailerType(.arrow)
            case 1:
                rowView.value("未绑定")
                    .trailerType(.arrow)
            case 2:
                rowView.value("188 **** 8888")
            case 3:
                rowView.placeholder("请输入手机号")
            case 4:
                rowView.details("188 8888 8888")
                    .leftStackAxis(.vertical)
                    .leftStackSpacing(6)
                    .trailerType(.arrow)
            case 5:
                rowView.details("我是 DeepSeek，很高兴见到你！")
                    .leftStackAxis(.vertical)
                    .leftStackSpacing(6)
                    .trailerType(.switch)
                    .trailerVerAlign(.title)
            case 6:
                rowView
                    .icon(size: CGSize(width: 55, height: 55))
                    .details("我是 DeepSeek，很高兴见到你！")
                    .leftStackAxis(.vertical)
                    .leftStackSpacing(6)
                    .trailerType(.arrow)
                
                rowView.iconImageView.corner(27.5)
                    .backgroundColor(.green)
            
            case 7:
                rowView
                    .icon(size: CGSize(width: 55, height: 55))
                    .details("我是 DeepSeek，很高兴见到你！")
                    .trailerType(.arrow)
                
                rowView.iconImageView.corner(27.5)
                    .backgroundColor(.green)
                
            case 8:
                rowView.title("密码")
                    .placeholder("请输入密码")
                    .leftStackAxis(.vertical)
                    .leftStackSpacing(6)
                    .trailerType(.password)
            default:
                break
            }
            return rowView
        }
        
        let stackView = UIStackView(arrangedSubviews: [iconRowView] + subviews)
            .set(spacing: 1)
            .set(axis: .vertical)
            .set(distribution: .equalSpacing)
            .addTo(view)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(83)
            make.leading.equalTo(14)
            make.centerX.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

