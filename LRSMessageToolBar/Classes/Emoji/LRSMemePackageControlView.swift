//
//  LRSMemePackageControlView.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/17.
//

import UIKit

class LRSMemePackageControlView: UIView {

    struct Configure {
        let buttonSize: CGSize
        let rows: Int
        let columns: Int
    }

    var viewWidth: CGFloat {
        return UIScreen.main.width
    }

    var scrollViewEdgeInsets: UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 0, right: 10)
    }

    lazy var pageControl: LRSMessageToolBarPageControl = LRSMessageToolBarPageControl(numberOfPages: page).then {
        $0.offColor = .color(named: "Color_192") ?? .lightGray
        $0.onColor = .black
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(pageControlTouched(control:)), for: .valueChanged)
    }

    lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.isPagingEnabled = true;
        $0.showsHorizontalScrollIndicator = false;
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
    }

    let itemHandler: LRSMemeSinglePage.ItemHandler
    let deleteHandler: LRSMemeSinglePage.ItemHandler

    var emojis: [LRSMemePackageConfigure.Item]?

    private var page: Int {
        guard let emojis = emojis else {
            return 0
        }
        let count = max(configure.rows * configure.columns - 1, 0)
        var page = emojis.count / count
        if emojis.count % count == 0 {

        } else {
            page += 1
        }
        return page
    }
    let configure: Configure

    init(itemHandler: @escaping LRSMemeSinglePage.ItemHandler, deleteHandler: @escaping LRSMemeSinglePage.ItemHandler, uiConfigure: Configure, emojis: [LRSMemePackageConfigure.Item]?) {
        self.itemHandler = itemHandler
        self.deleteHandler = deleteHandler
        self.configure = uiConfigure
        self.emojis = emojis
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func pageControlTouched(control: LRSMessageToolBarPageControl) {
        scrollView.setContentOffset(CGPoint(x: viewWidth * CGFloat(control.currentPage), y: 0), animated: true)
    }

    func buildUIWithTotalHeight(memePackageBoardHeight: CGFloat) {
        addSubview(scrollView)
        addSubview(pageControl)

        let pageControlSize = pageControl.size()
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.size.equalTo(pageControlSize)
            make.centerX.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }

        let contentView = UIView().then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        guard let emojis = emojis else {
            return
        }
        var items: [LRSMemePackageConfigure.Item] = []
        var list: [[LRSMemePackageConfigure.Item]] = []
        for (offset, element) in emojis.enumerated() {
            items.append(element)
            if items.count == configure.columns * configure.rows - 1 || offset == emojis.count - 1 {
                list.append(items)
                items.removeAll()
            }
        }
        let xSpacing = (viewWidth - CGFloat(configure.columns) * configure.buttonSize.width - (scrollViewEdgeInsets.left + scrollViewEdgeInsets.right)) / CGFloat(configure.columns - 1)
        let boarderHeight = memePackageBoardHeight - pageControlSize.height - (scrollViewEdgeInsets.top + scrollViewEdgeInsets.bottom)
        let ySpacing = (boarderHeight - CGFloat(configure.rows) * configure.buttonSize.height) / CGFloat(configure.rows - 1)

        list.enumerated().forEach { (offset, emojis) in
            let configure = LRSMemeSinglePage.Configure(buttonSize: configure.buttonSize, rows: configure.rows, columns: configure.columns, xSpacing: xSpacing, ySpacing: ySpacing, font: UIFont(name: "Apple color emoji", size: 32) ?? .systemFont(ofSize: 32))
            let page = LRSMemeSinglePage(itemHandler: itemHandler, deleteHandler: deleteHandler, uiConfigure: configure)
            page.emojis = emojis
            contentView.addSubview(page)
            page.snp.makeConstraints { make in
                make.left.equalTo(CGFloat(offset) * viewWidth + scrollViewEdgeInsets.left);
                make.top.equalTo(contentView).offset(scrollViewEdgeInsets.top);
                make.bottom.equalTo(contentView).offset(-scrollViewEdgeInsets.bottom);
                make.width.equalTo(viewWidth - (scrollViewEdgeInsets.left + scrollViewEdgeInsets.right));
                if (offset == list.count - 1) {
                    make.right.equalTo(contentView).offset(-scrollViewEdgeInsets.right);
                }
                make.height.equalTo(boarderHeight);
            }
        }

    }

}


extension LRSMemePackageControlView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newPageNumber = Int(scrollView.contentOffset.x / (viewWidth - scrollViewEdgeInsets.left - scrollViewEdgeInsets.right))
        if (pageControl.currentPage == newPageNumber) {
            return;
        }
        pageControl.currentPage = newPageNumber;
    }
}
