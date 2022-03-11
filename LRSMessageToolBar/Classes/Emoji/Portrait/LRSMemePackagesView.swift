//
//  LRSMemePackagesView.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/17.
//

import UIKit

class LRSMemePackagesView: UIView {
    public typealias ItemHandler = (LRSMemePackagesView, LRSMemePackageConfigure.Item?) -> ()

    public var boardHeight: CGFloat {
        return memeBoardHeight + LRSMessageToolBarHelper.safeAreaHeight
    }

    public var memeBoardHeight: CGFloat {
        return 280
    }

    lazy var memeContentView = LRSMemePackagesContentView(frame: .zero).then {
        $0.itemHandler = itemHandler
    }

    lazy var actionsView = LRSMemePackagesActionsView().then {
        $0.sendButton.addTarget(self, action: #selector(onClickedSendOut), for: .touchUpInside)
        $0.deleteButton.addTarget(self, action: #selector(onClickedDelete), for: .touchUpInside)
    }

    let itemHandler: LRSMemePackagesContentView.ItemHandler
    let deleteHandler: ItemHandler
    let confirmHandler: ItemHandler

    init(itemHandler: @escaping LRSMemePackagesContentView.ItemHandler,
         deleteHandler: @escaping ItemHandler,
         confirmHandler: @escaping ItemHandler) {
        self.itemHandler = itemHandler
        self.deleteHandler = deleteHandler
        self.confirmHandler = confirmHandler
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onClickedSendOut() {
        confirmHandler(self, nil)
    }

    @objc private func onClickedDelete() {
        deleteHandler(self, nil)
    }

    func buildUI(configures: LRSMemePackageConfigure) {
        addSubview(memeContentView)
        addSubview(actionsView)

        memeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let actionsViewSize = CGSize(width: 150, height: 84 + LRSMessageToolBarHelper.safeAreaHeight)
        actionsView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.size.equalTo(actionsViewSize)
        }
        memeContentView.buildUI(configure: configures, actionsViewSize: actionsViewSize)
    }

}
