//
//  LRSMemeSinglePage.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/17.
//

import UIKit

class LRSMemeSinglePage: UIView {
    typealias ItemHandler = (LRSMemeSinglePage, LRSMemePackageConfigure.Item?) -> ()

    static let deleteButtonTag = 999
    let itemHandler: ItemHandler
    let deleteHandler: ItemHandler

    var emojis: [LRSMemePackageConfigure.Item]? {
        didSet {
            subviews.forEach { $0.removeFromSuperview() }
            for (offset, object) in emojis!.enumerated() {
                let row: Int = offset / uiConfigure.columns
                let column: Int = offset % uiConfigure.columns
                let button = buildButton(row: row, column: column)
                button.titleLabel?.font = uiConfigure.font
                button.tag = 100 + offset
                button.setTitle(object.emojiValue, for: .normal)
            }
            let button = buildButton(row: uiConfigure.rows - 1, column: uiConfigure.columns - 1)
            button.setImage(.image(named: "faceDelete"), for: .normal)
            button.tag = .deleteButtonTag
        }
    }

    struct Configure {
        let buttonSize: CGSize
        let rows: Int
        let columns: Int
        let xSpacing: CGFloat
        let ySpacing: CGFloat
        let font: UIFont
    }

    let uiConfigure: Configure
    
    init(itemHandler: @escaping ItemHandler, deleteHandler: @escaping ItemHandler, uiConfigure: Configure) {
        self.itemHandler = itemHandler
        self.deleteHandler = deleteHandler
        self.uiConfigure = uiConfigure
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildButton(row: Int, column: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(emojiButtonPressed(button:)), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalTo(Double(column) * (uiConfigure.buttonSize.width + uiConfigure.xSpacing))
            make.top.equalTo(Double(row) * (uiConfigure.buttonSize.height + uiConfigure.ySpacing))
            make.size.equalTo(uiConfigure.buttonSize)
        }
        return button
    }

    @objc private func emojiButtonPressed(button: UIButton) {
        if button.tag == .deleteButtonTag {
            deleteHandler(self, nil)
        }
        let index = button.tag - 100
        if index >= 0 && index < emojis?.count ?? 0 {
            itemHandler(self, emojis?[index])
        }
    }

}


fileprivate extension Int {
    static let deleteButtonTag = 999
}
