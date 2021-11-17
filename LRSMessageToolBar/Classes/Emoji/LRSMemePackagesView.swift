//
//  LRSMemePackagesView.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/17.
//

import UIKit

class LRSMemePackagesView: UIView {

    public typealias ItemHandler = (LRSMemePackagesView) -> ()

    public var boardHeight: CGFloat {
        return memeBoardHeight + LRSMessageToolBarHelper.safeAreaHeight + actionButtonHeight
    }

    public var memeBoardHeight: CGFloat {
        return 213
    }

    public var actionButtonHeight: CGFloat {
        return 40
    }


    lazy var mainScrollView: UIScrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false;
        $0.showsVerticalScrollIndicator = false
    }

    lazy var barScrollView: UIScrollView = UIScrollView().then{
        $0.showsHorizontalScrollIndicator = false;
        $0.showsVerticalScrollIndicator = false
    }

    lazy var sendEmojiButton: UIButton = UIButton(type: .custom).then {
        $0.setBackgroundImage(.image(named: "information_send"), for: .normal)
        $0.setTitle("发送", for: .normal)
        $0.setTitleColor(UIColor.color(named: "Color_30"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(sendOut), for: .touchUpInside)
    }

    let itemHandler: LRSMemeSinglePage.ItemHandler
    let deleteHandler: LRSMemeSinglePage.ItemHandler
    let confirmHandler: ItemHandler

    init( itemHandler: @escaping LRSMemeSinglePage.ItemHandler,
         deleteHandler: @escaping LRSMemeSinglePage.ItemHandler,
         confirmHandler: @escaping ItemHandler) {
        self.itemHandler = itemHandler
        self.deleteHandler = deleteHandler
        self.confirmHandler = confirmHandler
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func sendOut() {
        confirmHandler(self)
    }

    func buildUI(configures: [LRSMemePackageConfigure]) {
        addSubview(mainScrollView)
        addSubview(barScrollView)
        addSubview(sendEmojiButton)

        let mainContentView = UIView().then {
            mainScrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        mainScrollView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(barScrollView.snp.top)
        }

        let barContentView = UIView().then {
            barScrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        barScrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(sendEmojiButton.snp.left)
            make.centerY.equalTo(sendEmojiButton)
            make.height.equalTo(sendEmojiButton)
        }

        sendEmojiButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(-LRSMessageToolBarHelper.safeAreaHeight)
            make.width.equalTo(60)
            make.height.equalTo(actionButtonHeight)
        }

        configures.enumerated().forEach { (offset, element) in
            let size = LRSMessageToolBarHelper.sizeOfEmoji(key: element.key)
            let emojiView = LRSMemePackageControlView(
                itemHandler: itemHandler,
                deleteHandler: deleteHandler,
                uiConfigure: LRSMemePackageControlView.Configure(
                    buttonSize: size,
                    rows: element.row,
                    columns: element.column
                ),
                emojis: element.emojis
            )
            mainContentView.addSubview(emojiView)
            emojiView.buildUIWithTotalHeight(memePackageBoardHeight: memeBoardHeight)
            emojiView.snp.makeConstraints { make in
                make.left.equalTo(UIScreen.main.width * CGFloat(offset))
                make.top.bottom.equalToSuperview()
                make.width.equalTo(UIScreen.main.width)
                if (offset == configures.count - 1) {
                    make.right.equalToSuperview()
                }
                make.height.equalTo(memeBoardHeight);
            }

            let coverButton = UIButton(type: .custom)
            coverButton.setImage(.image(named: element.coverImageName), for: .normal)
            coverButton.backgroundColor = .color(named: "Color_244")
            barContentView.addSubview(coverButton)
            coverButton.snp.makeConstraints { make in
                make.left.equalTo(actionButtonHeight * CGFloat(offset));
                make.top.bottom.equalToSuperview()
                make.height.width.equalTo(actionButtonHeight);
                if (offset == configures.count - 1) {
                    make.right.equalToSuperview()
                }
            }
        }
    }

}
