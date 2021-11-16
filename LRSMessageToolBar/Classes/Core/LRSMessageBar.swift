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
        let toolBottomOffset: CGFloat = 10
        let memeAnimationDuration: TimeInterval = 0.3
        let memeAnimationOffset: CGFloat = 50
    }

    @objc open weak var delegate: LRSMesssageBarProtocol?
    @objc public let configure: LRSMessageToolBarConfigure
    @objc public let toolBar: LRSMessageInputBar
    @objc public lazy var memePackagesView = LRSMemePackagesView(frame: .zero, configures: LRSMessageToolBarHelper.allEmojis())
    private var mode: Mode = .normal
    private var memeBoardHeight: CGFloat = LRSMemePackagesView.boardHeight()
    private let uiConfigure = BarConfigure()
    private var audioPermission = true

    var textViewHeight: CGFloat {
        let textView = toolBar.inputTextView
        let height = textView.sizeThatFits(textView.bounds.size).height
        let minHeight = configure.textViewConfigure.minHeight
        let maxHeight = configure.textViewConfigure.maxHeight
        return min(maxHeight, max(minHeight, height))
    }

    @objc public init(frame: CGRect, configure: LRSMessageToolBarConfigure = .default()) {
        self.configure = configure
        toolBar = LRSMessageInputBar.toolBar(with: configure)
        super.init(frame: frame)
        buildUI()
        addObservers()
    }

    required init?(coder: NSCoder) {
        configure = .default()
        toolBar = LRSMessageInputBar.toolBar(with: configure)
        super.init(coder: coder)
        buildUI()
        addObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("dealloc")
    }

    @discardableResult public override func resignFirstResponder() -> Bool {
        if mode == .keyboard {
            toolBar.inputTextView.resignFirstResponder()
        } else if mode == .meme {
            animationHiddenMemePackagesView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animationResignFirstResponder(duration: 0.3)
            }
        }
        mode = .normal
        return super.resignFirstResponder()
    }

    @discardableResult public override func becomeFirstResponder() -> Bool {
        if mode == .normal {
            if toolBar.mode == .textInput {
                toolBar.inputTextView.becomeFirstResponder()
            } else {

            }
        } else if mode == .meme {
            onSwithMemeMode(button: toolBar.faceButton)
        }
        return true
    }

    private func buildUI() {
        toolBar.frame = CGRect(x: 0, y: 0, width: LRSMessageToolBarHelper.screenWidth(), height: self.textViewHeight)
        addSubview(toolBar)
        memePackagesView.itemHandler = {[unowned self] _, item in
            toolBar.inputTextView.text += item.emojiValue
            let offset = toolBarPosition()
            plus(offset: offset)
            memePackagesView.y(to: memePackagesView.frame.origin.y - offset)
        }

        memePackagesView.backspaceHandler = {[unowned self] _ in
            toolBar.inputTextView.deleteBackward()
        }

        memePackagesView.confirmHandler = {[unowned self] _ in
            sendMessage()
        }

        toolBar.recordingBtn.touchBegan = { [unowned self] button in
            if let permission = delegate?.audioPermission?() {
                audioPermission = permission
            }
            guard audioPermission == true else {
                toolBar.recordingBtn.isSelected = false
                return
            }
            delegate?.messageToolBarBeganToSpeak(bar: self)
        }

        toolBar.recordingBtn.touchEnd = { [unowned self] _ in
            delegate?.messageToolBarEndSpeaking(bar: self)
        }

        toolBar.recordingBtn.dragEnter = { [unowned self] _ in
            delegate?.messageToolBarDragEnterRecordScope(bar: self)
        }

        toolBar.recordingBtn.dragOutside = { [unowned self] _ in
            delegate?.messageToolBarDragOutRecordScope(bar: self)
        }

        toolBar.recordingBtn.dragOutsideRelease = { [unowned self] _ in
            delegate?.messageToolBarSlideTopToCancelRecording(bar: self)
        }

        memePackagesView.buildUI()
        toolBar.faceButton.addTarget(self, action: #selector(onSwithMemeMode(button:)), for: .touchUpInside)
        toolBar.modeSwitchButton.addTarget(self, action: #selector(onSwithButtonClicked(button:)), for: .touchUpInside)
    }

    @objc func onSwithButtonClicked(button: UIButton) {
        switch toolBar.mode {
        case .record:
            mode = .normal
            toolBar.inputTextView.resignFirstResponder()
            toolBar.height(to: 35)
            animationHiddenMemePackagesView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animationResignFirstResponder(duration: 0.3)
            }
        case .textInput:
            toolBarPosition()
            break
        }
    }

    @objc private func onSwithMemeMode(button: UIButton) {
        if mode == .normal || mode == .keyboard {
            mode = .meme
            toolBar.inputTextView.resignFirstResponder()
            animationBecomeFirstResponder(duration: uiConfigure.memeAnimationDuration, bottomHeight: self.memeBoardHeight)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animationShowMemePackagesView()
            }
        } else {
            toolBar.inputTextView.becomeFirstResponder()
            mode = .keyboard
            animationHiddenMemePackagesView()
        }
    }

    private func addObservers() {
        toolBar.inputTextView.delegate = self

        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: .main) {[unowned self] noti in
            let info = noti.userInfo
            let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            let to = info?[UIKeyboardFrameEndUserInfoKey] as? CGRect
            animationBecomeFirstResponder(duration: duration ?? 0.3, bottomHeight: to?.size.height ?? 100)
            mode = .keyboard
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: .main) {[unowned self] noti in
            if mode == .keyboard {
                let info = noti.userInfo
                let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as? Double
                animationResignFirstResponder(duration: duration ?? 0.3)
            }
        }
    }

    private func sendMessage() {
        let str = toolBar.inputTextView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        delegate?.messageToolBarDidClickedReturn(bar: self, text: str)
        toolBar.inputTextView.text = ""
        toolBar.inputTextView.setContentOffset(.zero, animated: true)
        let offset = toolBarPosition()
        plus(offset: offset)
        if mode == .meme {
            memePackagesView.y(to: memePackagesView.frame.origin.y - offset)
        }
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
        return delegate?.messageToolBarShouldBeginEditting(bar: self) ?? true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.messageToolBarInputTextViewDidEndEditing(bar: self)
        UIView.animate(withDuration: 0.1) {
            self.toolBar.bottomLine.alpha = 1
        }
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        guard let end = textView.selectedTextRange?.end else {
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
        let length = configure.textViewConfigure.acceptLength
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
        let y = LRSMessageToolBarHelper.screenHeight() - toolBar.bounds.size.height - LRSMessageToolBarHelper.safeAreaHeight()
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
        let y = LRSMessageToolBarHelper.screenHeight() - height
        var rect = frame
        rect.origin.y = y
        rect.size.height = height
        UIView.animate(withDuration: uiConfigure.memeAnimationDuration) {
            self.frame = rect
        }
    }
}

