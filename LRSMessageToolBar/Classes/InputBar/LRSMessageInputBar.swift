//
//  LRSMessageInputBar.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/16.
//

import UIKit
import SnapKit

@objc public class LRSMessageInputBar: UIView {

    enum Mode {
        case input
        case record
    }

    private let configure: LRSMessageToolBarConfigure
    var mode: Mode = .input {
        willSet {
            switchMode(m: newValue)
        }
    }

    lazy var modeSwitchButton: UIButton = UIButton(type: .custom).then {
        $0.addTarget(self, action: #selector(modeSwitchClick(button: )), for: .touchUpInside)
    }

    @objc lazy var recordingBtn: LRSMessageToolBarRecordButton =  LRSMessageToolBarRecordButton(frame: .zero).then {
        $0.build(state: configure.recordButton.state)
        $0.isHidden = true
        $0.clickTime = configure.recordButton.clickTime
        $0.areaY = configure.textView.minHeight
    }

    @objc public lazy var inputTextView: LRSPlaceholderTextView = LRSPlaceholderTextView().then {
        $0.font = .systemFont(ofSize: 16)
        $0.autoresizingMask = .flexibleHeight
        $0.returnKeyType = .send
        $0.enablesReturnKeyAutomatically = true
        $0.backgroundColor = .clear
        $0.keyboardType = .default
        $0.undoManager?.disableUndoRegistration()
        $0.placeHolder = configure.textView.placeholder
        $0.placeHolderColor = configure.textView.placeHolderColor
    }

    lazy var faceButton: UIButton = UIButton(type: .custom).then {
        $0.build(state: configure.buttons.emojiButtonState)
    }

    @objc public lazy var imagePickButton: UIButton = UIButton(type: .custom).then {
        $0.build(state: configure.buttons.imagePickerButtonState)
    }

    lazy var bottomLine: UIView = UIView().then {
        $0.backgroundColor = .color(named: "Color_226")
    }

    public init(frame: CGRect, configure: LRSMessageToolBarConfigure = .default) {
        self.configure = configure
        super.init(frame: frame)
        loadBasicSubviews()
        switchMode(m: .input)
    }

    required public init?(coder: NSCoder) {
        fatalError()
    }

    private func loadBasicSubviews() {
        addSubview(imagePickButton)
        addSubview(faceButton)
        addSubview(inputTextView)
        addSubview(recordingBtn)
        addSubview(modeSwitchButton)
        addSubview(bottomLine)

        bottomLine.snp.makeConstraints { make in
            make.bottom.equalTo(inputTextView.snp.bottom)
            make.left.right.equalTo(inputTextView)
            make.height.equalTo(0.5)
        }
        modeSwitchButton.snp.makeConstraints { make in
            make.left.equalTo(configure.modeSwitch.leftMargin)
            make.size.equalTo(configure.modeSwitch.buttonSize)
            make.centerY.equalTo(inputTextView)
        }

        recordingBtn.snp.makeConstraints { make in
            make.left.equalTo(modeSwitchButton.snp.right).offset(configure.textView.leftMargin)
            make.top.equalTo(configure.textView.topMargin)
            make.right.equalTo(imagePickButton.snp.left).offset(-configure.textView.topMargin)
            make.height.equalTo(configure.textView.minHeight)
        }

        inputTextView.snp.makeConstraints { make in
            make.left.top.equalTo(recordingBtn)
            make.right.equalTo(faceButton.snp.left).offset(-configure.textView.topMargin)
            make.bottom.equalToSuperview()
        }

        imagePickButton.snp.makeConstraints { make in
            make.right.equalTo(-configure.buttons.rightButtonsMargin)
            make.centerY.equalTo(modeSwitchButton)
            make.width.height.equalTo(modeSwitchButton)
        };
        faceButton.snp.makeConstraints { make in
            make.size.equalTo(imagePickButton)
            make.centerY.equalTo(imagePickButton)
            make.right.equalTo(imagePickButton.snp.left).offset(configure.buttons.rightButtonsXSpacing)
        };
    }

    @objc private func modeSwitchClick(button: UIButton) {
        mode = mode == .input ? .record : .input
        if mode == .record {
            inputTextView.resignFirstResponder()
            recordingBtn.isSelected = false
        } else {
            inputTextView.becomeFirstResponder()
        }
    }

    private func switchMode(m: Mode) {
        recordingBtn.isHidden = m == .input
        modeSwitchButton.isSelected = !recordingBtn.isHidden
        inputTextView.isHidden = !recordingBtn.isHidden
        faceButton.isHidden = inputTextView.isHidden
        bottomLine.isHidden = LRSMessageToolBarHelper.safeAreaHeight == 0 || inputTextView.isHidden
        modeSwitchButton.setImage(configure.modeSwitch.state.image(for: m == .input ? .normal: .selected), for: .normal)
    }

}


fileprivate extension UIButton {
    func build(state: LRSMessageToolBarConfigure.ButtonState) {
        state.imageSource.forEach { key, value in
            setImage(value, for: key)
        }

        state.titleSource.forEach { key, value in
            setAttributedTitle(value, for: key)
        }
    }
}

fileprivate extension LRSMessageToolBarRecordButton {
    func build(state: LRSMessageToolBarConfigure.ButtonState) {
        state.imageSource.forEach { key, value in
            setImage(value, for: key)
        }

        state.titleSource.forEach { key, value in
            setTitle(value, for: key)
        }
    }
}
