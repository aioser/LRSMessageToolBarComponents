//
//  LRSMessageBar.swift
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/11/9.
//

import UIKit

@objc public class LRSMessageBar: UIView {

    enum Mode {
        case normal
        case keyboard
        case meme
    }

    struct BarConfigure {
        let toolBottomOffset: CGFloat = 0
        let memeAnimationDuration: TimeInterval = 0.3
        let memeAnimationOffset: CGFloat = 50
    }

    @objc
    open weak var delegate: LRSMesssageBarProtocol?

    @objc
    public let toolBar: LRSMessageInputBar

    private let configure: LRSMessageToolBarConfigure

    private lazy var itemHandler: LRSMemePackagesContentView.ItemHandler = {[weak self] page, item in
        self?.append(text: item?.emojiValue)
    }

    private lazy var deleteHandler: LRSMemePackagesView.ItemHandler = {[weak self] _, _ in
        self?.toolBar.inputTextView.deleteBackward()
    }

    private lazy var confirmHandler: LRSMemePackagesView.ItemHandler = {[weak self] _,_  in
        self?.sendMessage()
    }

    private lazy var memePackagesView = LRSMemePackagesView(itemHandler: itemHandler, deleteHandler: deleteHandler, confirmHandler: confirmHandler).then {
        $0.backgroundColor = .color(named: "Color_244")
    }

    private var mode: Mode = .normal {
        willSet {
            toolBar.faceButton.isSelected = newValue == .meme
        }
    }
    private var memeBoardHeight: CGFloat {
        return memePackagesView.boardHeight
    }
    private let uiConfigure = BarConfigure()
    private var audioPermission = true

    var textViewHeight: CGFloat {
        let textView = toolBar.inputTextView
        let height = textView.sizeThatFits(textView.bounds.size).height
        let minHeight = configure.textView.minHeight
        let maxHeight = configure.textView.maxHeight
        return min(maxHeight, max(minHeight, height) + configure.textView.topMargin * 2)
    }

    @objc public init(frame: CGRect, configure: LRSMessageToolBarConfigure) {
        self.configure = configure
        toolBar = LRSMessageInputBar(frame: .zero, configure: configure)
        super.init(frame: frame)
        buildUI()
        addObservers()
    }

    required init?(coder: NSCoder) {
        configure = .default
        toolBar = LRSMessageInputBar(frame: .zero, configure: configure)
        super.init(coder: coder)
        buildUI()
        addObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("LRSMessageBar -- dealloc")
    }

    @objc public func append(text: String?) {
        guard let value = text else {
            return
        }
        toolBar.inputTextView.text += value
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: toolBar.inputTextView)
        let offset = toolBarPosition()
        plus(offset: offset)
        memePackagesView.y(to: memePackagesView.frame.origin.y - offset)
        toolBar.scrollToEnd()
    }

    @objc @discardableResult public override func resignFirstResponder() -> Bool {
        if mode == .keyboard {
            toolBar.inputTextView.resignFirstResponder()
        } else if mode == .meme {
            animationHiddenMemePackagesView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                self?.animationResignFirstResponder(duration: 0.3)
            }
        }
        mode = .normal
        return super.resignFirstResponder()
    }

    @objc @discardableResult public override func becomeFirstResponder() -> Bool {
        if mode == .normal {
            if toolBar.mode == .input {
                toolBar.inputTextView.becomeFirstResponder()
            } else {

            }
        } else if mode == .meme {
            onSwithMemeMode(button: toolBar.faceButton)
        }
        return true
    }

    private func buildUI() {
        toolBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.width, height: textViewHeight)
        addSubview(toolBar)

        memePackagesView.buildUI(configures: LRSMessageToolBarHelper.emojis() ?? LRSMemePackageConfigure(emojis: [], columnCount: 9))

        toolBar.recordingBtn.touchBegan = { [unowned self] button in
            if let permission = delegate?.audioPermission?() {
                audioPermission = permission
            }
            guard audioPermission == true else {
                toolBar.recordingBtn.isSelected = false
                return
            }
            delegate?.messageToolBarBeganToSpeak?(bar: self)
        }

        toolBar.recordingBtn.touchEnd = { [unowned self] _ in
            delegate?.messageToolBarEndSpeaking?(bar: self)
        }

        toolBar.recordingBtn.dragEnter = { [unowned self] _ in
            delegate?.messageToolBarDragEnterRecordScope?(bar: self)
        }

        toolBar.recordingBtn.dragOutside = { [unowned self] _ in
            delegate?.messageToolBarDragOutRecordScope?(bar: self)
        }

        toolBar.recordingBtn.dragOutsideRelease = { [unowned self] _ in
            delegate?.messageToolBarSlideTopToCancelRecording?(bar: self)
        }

        toolBar.faceButton.addTarget(self, action: #selector(onSwithMemeMode(button:)), for: .touchUpInside)
        toolBar.modeSwitchButton.addTarget(self, action: #selector(onSwithButtonClicked(button:)), for: .touchUpInside)
    }

    @objc func onSwithButtonClicked(button: UIButton) {
        switch toolBar.mode {
        case .record:
            mode = .normal
            toolBar.inputTextView.resignFirstResponder()
            toolBar.height(to: configure.textView.minHeight + configure.textView.topMargin * 2)
            animationHiddenMemePackagesView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                self?.animationResignFirstResponder(duration: 0.3)
            }
        case .input:
            toolBarPosition()
            break
        }
    }

    @objc private func onSwithMemeMode(button: UIButton) {
        if mode == .normal || mode == .keyboard {
            mode = .meme
            toolBar.inputTextView.resignFirstResponder()
            animationBecomeFirstResponder(duration: uiConfigure.memeAnimationDuration, bottomHeight: self.memeBoardHeight)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                self?.animationShowMemePackagesView()
            }
        } else {
            toolBar.inputTextView.becomeFirstResponder()
            mode = .keyboard
            animationHiddenMemePackagesView()
        }
    }

    private func addObservers() {
        toolBar.inputTextView.delegate = self

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {[weak self] noti in
            let info = noti.userInfo
            let duration = info?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            let to = info?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            self?.animationBecomeFirstResponder(duration: duration ?? 0.3, bottomHeight: to?.size.height ?? 100)
            self?.mode = .keyboard
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {[weak self] noti in
            if self?.mode == .keyboard {
                let info = noti.userInfo
                let duration = info?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                self?.animationResignFirstResponder(duration: duration ?? 0.3)
            }
        }
    }

    private func sendMessage() {
        let str = toolBar.inputTextView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        delegate?.messageToolBarDidClickedReturn?(bar: self, text: str)
        toolBar.inputTextView.text = ""
        toolBar.inputTextView.setContentOffset(.zero, animated: true)
        let offset = toolBarPosition()
        plus(offset: offset)
        if mode == .meme {
            memePackagesView.y(to: memePackagesView.frame.origin.y - offset)
        }
        delegate?.sendOut(bar: self, text: str)
    }
}

extension LRSMessageBar: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.messageToolBarInputTextViewDidBeginEditing?(bar: self)
        UIView.animate(withDuration: 0.3) {
            var memeRect = self.memePackagesView.frame
            memeRect.origin.y = self.textViewHeight + self.memeBoardHeight
            self.memePackagesView.frame = memeRect
            self.toolBar.bottomLine.alpha = 0
        }
    }

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.messageToolBarShouldBeginEditting?(bar: self) ?? true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.messageToolBarInputTextViewDidEndEditing?(bar: self)
        UIView.animate(withDuration: 0.1) {
            self.toolBar.bottomLine.alpha = 1
        }
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        guard let end = textView.selectedTextRange?.end, textView.selectedRange.length != 0 else {
            return
        }
        let r = textView.caretRect(for: end)
        let y = max(r.origin.y - textView.frame.size.height + r.size.height + 8, 0)
        if textView.contentOffset.y < y && r.origin.y != .infinity {
            textView.contentOffset = CGPoint(x: 0, y: y)
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendMessage()
            return false
        }
        return true
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    public func textViewDidChange(_ textView: UITextView) {
        let length = configure.textView.acceptLength
        if textView.text.count < length {

        } else {
            textView.text = String(textView.text.prefix(length))
        }
        let offset = toolBarPosition()
        plus(offset: offset)
        if mode == .meme {
            memePackagesView.y(to: memePackagesView.frame.origin.y - offset)
        }
    }

}


private extension UIView {
    func plus(offset: CGFloat) {
        var selfRect = self.frame
        selfRect.origin.y += offset
        selfRect.size.height -= offset
        self.frame = selfRect
    }

    func height(to: CGFloat) {
        var rect = self.frame
        rect.size.height = to
        self.frame = rect
    }

    func y(to: CGFloat) {
        var rect = self.frame
        rect.origin.y = to
        self.frame = rect
    }

}

private extension LRSMessageBar {

    @discardableResult func toolBarPosition() -> CGFloat {
        let offset = toolBar.bounds.size.height - textViewHeight
        toolBar.height(to: textViewHeight)
        return offset
    }

    private func animationHiddenMemePackagesView() {
        UIView.animate(withDuration: uiConfigure.memeAnimationDuration) {
            var memeRect = self.memePackagesView.frame
            memeRect.origin.y = self.textViewHeight + 30
            self.memePackagesView.frame = memeRect
            self.memePackagesView.alpha = 0
        }
    }

    private func animationResignFirstResponder(duration: TimeInterval) {
        let y = UIScreen.main.height - toolBar.bounds.size.height - LRSMessageToolBarHelper.safeAreaHeight
        var rect = frame
        rect.origin.y = y
        UIView.animate(withDuration: duration) {
            self.frame = rect
        }
    }

    private func animationShowMemePackagesView() {
        let y = textViewHeight + uiConfigure.memeAnimationOffset
        let rect = frame
        memePackagesView.frame = CGRect(x: 0, y: y, width: rect.size.width, height: memeBoardHeight)
        memePackagesView.alpha = 0
        if let _ = memePackagesView.superview {

        } else {
            addSubview(memePackagesView)
        }
        var memeRect = memePackagesView.frame
        memeRect.origin.y = textViewHeight + uiConfigure.toolBottomOffset

        UIView.animate(withDuration: uiConfigure.memeAnimationDuration) {
            self.memePackagesView.frame = memeRect
            self.memePackagesView.alpha = 1
        }
    }

    private func animationBecomeFirstResponder(duration: TimeInterval, bottomHeight: CGFloat) {
        let height = textViewHeight + bottomHeight + uiConfigure.toolBottomOffset
        let y = UIScreen.main.height - height
        var rect = frame
        rect.origin.y = y
        rect.size.height = height
        UIView.animate(withDuration: uiConfigure.memeAnimationDuration) {
            self.frame = rect
        }
    }
}

