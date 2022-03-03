//
//  LRSMemePackagesActionsView.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2022/3/2.
//

import UIKit
import SnapKit

class LRSMemePackagesActionsView: UIView {

    lazy var sendButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = .color(named: "Color_255_224_58")
        $0.setTitle("发送", for: .normal)
        $0.setTitleColor(UIColor.color(named: "Color_30"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.color(named: "Color_240_202_0")?.cgColor
    }

    lazy var deleteButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(.image(named: "im_emoji_deleate"), for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.color(named: "Color_226")?.cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        var image = UIImage.image(named: "ic_emoji_mask")
//        image = image?.stretchableImage(withLeftCapWidth: Int((image?.size.width ?? 0) / 2, topCapHeight: Int((image?.size.height ?? 0) / 2 )))
        let mask = UIImageView(image: image)
        addSubview(mask)
        mask.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(sendButton)
        addSubview(deleteButton)
        sendButton.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 52, height: 40))
            make.top.equalTo(19)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(sendButton.snp.left).offset(-14)
            make.size.equalTo(sendButton)
            make.centerY.equalTo(sendButton)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
