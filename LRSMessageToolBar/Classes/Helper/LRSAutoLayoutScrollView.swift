//
//  LRSAutoLayoutScrollView.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2022/3/2.
//

import UIKit
import SnapKit

public class LRSAutoLayoutScrollView: UIScrollView {
    public lazy var contentView = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
