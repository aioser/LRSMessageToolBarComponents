//
//  LRSMessageToolBarRecordButton.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/16.
//

import UIKit
import SnapKit

@objc public class LRSMessageToolBarRecordButton: UIControl {

    typealias Action = (_ button: LRSMessageToolBarRecordButton) -> ()

    var touchBegan: Action?
    var touchEnd: Action?
    var dragOutside: Action?
    var dragEnter: Action?
    var dragOutsideRelease: Action?

    var clickTime: TimeInterval = 0
    var areaY: CGFloat = 0
    @objc public var inArea: Bool = false

    private lazy var backgroundImageView = UIImageView().then {
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private lazy var stateValue = LRSMessageToolBarConfigure.ButtonState()

    override var isSelected: Bool {
        willSet {
            if newValue == true {
                backgroundImageView.image = stateValue.image(for: .selected)
                titleLabel.attributedText = stateValue.title(for: .selected)
            } else {
                backgroundImageView.image = stateValue.image(for: .normal)
                titleLabel.attributedText = stateValue.title(for: .normal)
            }
        }
    }

    deinit {
        LRSMessageToolBarRecordButton.cancelPreviousPerformRequests(withTarget: self)
    }

    @objc private func begin() {
        print("Touch Began")
        self.isSelected = true
        touchBegan?(self)
        inArea = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LRSMessageToolBarRecordButton.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(begin), with: nil, afterDelay: clickTime, inModes: [.common])
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        LRSMessageToolBarRecordButton.cancelPreviousPerformRequests(withTarget: self)
        print("Touch End");
        if inArea == true {
            touchEnd?(self)
        } else {
            dragOutsideRelease?(self)
        }
        isSelected = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let point = touch?.location(in: self) else {
            dragOutside?(self)
            inArea = false
            return
        }
        let check = point.y >= 0 && point.y < areaY
        if check != inArea {
            if inArea {
                print("dragOutside");
                dragOutside?(self)
            } else {
                print("dragEnter");
                dragEnter?(self)
            }
        }
        inArea = check
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        LRSMessageToolBarRecordButton.cancelPreviousPerformRequests(withTarget: self)
        print("Touch Cancel");
        touchEnd?(self);
        isSelected = false
    }

    func setImage(_ image: UIImage?, for state: State) {
        stateValue.image(image, for: state)
    }

    func setTitle(_ title: NSAttributedString, for state: State) {
        stateValue.title(title, for: state)
    }
}
