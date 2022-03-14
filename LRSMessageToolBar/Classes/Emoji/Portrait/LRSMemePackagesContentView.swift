//
//  LRSMemePackagesContentView.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2022/3/2.
//

import UIKit
import Then
import SnapKit
class LRSMemePackagesContentView: UIControl {
    public typealias ItemHandler = (LRSMemePackagesContentView, LRSMemePackageConfigure.Item?) -> ()

    let itemSize = CGSize(width: 42, height: 42)

    let leftPadding: CGFloat = 11

    class EmojiItem: UIControl {
        var configure: LRSMemePackageConfigure.Item?

        func buildUI(configure: LRSMemePackageConfigure.Item) {
            self.configure = configure
            let label = UILabel().then {
                $0.font = UIFont(name: "Apple color emoji", size: 32) ?? .systemFont(ofSize: 32)
                $0.text = configure.emojiValue
            }
            addSubview(label)
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }

    lazy var items: [EmojiItem] = []
    var itemHandler: ItemHandler?

    lazy var mainScrollView = LRSAutoLayoutScrollView(frame: .zero).then {
        $0.showsHorizontalScrollIndicator = false;
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func buildUI(configure: LRSMemePackageConfigure, actionsViewSize: CGSize) {
        items.forEach {
            $0.removeFromSuperview()
        }
        items.removeAll()

        let itemSize = self.itemSize
        let leftPadding = self.leftPadding
        let topPadding: CGFloat = 15
        let itemXInterval = itemXInterval(itemSize: itemSize, leftPadding: leftPadding, configure: configure)
        let itemYInterval: CGFloat = 4
        configure.emojis.enumerated().forEach { (offset, element) in
            /// 计算当前 `offset` 所处的行和列
            let column: CGFloat = CGFloat(offset % configure.columnCount)
            let row: CGFloat = CGFloat(Int(offset / configure.columnCount))
            /// 基于行列计算 x 和 y
            let x = leftPadding + column * itemXInterval + column * itemSize.width
            let y = topPadding + row * itemYInterval + row * itemSize.height
            let item = EmojiItem().then {
                $0.buildUI(configure: element)
            }
            mainScrollView.contentView.addSubview(item)
            item.snp.makeConstraints { make in
                make.size.equalTo(itemSize)
                make.left.equalTo(x)
                make.top.equalTo(y)
                if offset == configure.emojis.count - 1 {
                    /// `Scrollview.contentSize.height` 容错
                    /// 首先计算出来最后一行 `emoji` 所占的宽度 `lastLineWidth`
                    /// 如果`lastLineWidth`和`actionsViewSize.width`过小(如: itemSize.width / 2), 则底部区域至少需要预留`actionsViewSize.height`
                    /// 反之, 不需要预留过高, 置为`actionsViewSize.height - itemSize.height` 即可
                    let lastLineEmojiCount: CGFloat = CGFloat(offset % configure.columnCount)
                    let lastLineWidth = lastLineEmojiCount * itemSize.width + (lastLineEmojiCount - 1) * itemXInterval + leftPadding
                    let bottom = (UIScreen.main.width - lastLineWidth - actionsViewSize.width) < (itemSize.width / 2) ? actionsViewSize.height : (actionsViewSize.height - itemSize.height)
                    make.bottom.equalTo(-bottom)
                }
                if offset == configure.columnCount - 1 {
                    make.right.equalToSuperview()
                }
            }
            items.append(item)
            item.addTarget(self, action: #selector(onClickedEmoji(button:)), for: .touchUpInside)
        }
    }

    func itemXInterval(itemSize: CGSize, leftPadding: CGFloat, configure: LRSMemePackageConfigure) -> CGFloat {
        let itemXInterval = (UIScreen.main.width - CGFloat(configure.columnCount) * itemSize.width - leftPadding * 2) / CGFloat(configure.columnCount - 1)
        return itemXInterval
    }

    @objc
    func onClickedEmoji(button: EmojiItem) {
        guard let handler = itemHandler else {
            return
        }
        handler(self, button.configure)
    }
}
