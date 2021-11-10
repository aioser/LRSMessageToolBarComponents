//
//  LRSMessageBar.swift
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/11/9.
//

import UIKit

enum Mode {
    case normal
    case keyboard
    case meme
}

@objc public class LRSMessageBar: UIView {

    private let configure: LRSMessageToolBarConfigure
    private let toolBar: LRSMessageInputBar
    private var mode: Mode = .normal
    private var memeBoardHeight: CGFloat = LRSMemePackagesView.boardHeight()

    @objc weak var delegate: LRSMesssageBarProtocol?

    private lazy var memePackagesView = LRSMemePackagesView(frame: .zero, configures: LRSMessageToolBarHelper.allEmojis())

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

    public func buildUI() {
        toolBar.frame = CGRect(x: 0, y: 0, width: LRSMessageToolBarHelper.screenWidth(), height: self.textViewHeight)
        addSubview(toolBar)
    }

    private func addObservers() {
        toolBar.inputTextView.delegate = self

        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: .main) {[unowned self] noti in
            let info = noti.userInfo
            let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            let to = info?[UIKeyboardFrameEndUserInfoKey] as? CGRect
            var y: CGFloat!
            switch mode {
            case .normal:
                y = (to?.origin.y ?? 100) - self.textViewHeight - 15
            default: return
            }
            var rect = self.frame
            rect.origin.y = y
            frameChange(to: rect, duration: duration)

        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: .main) {[unowned self] noti in
            let info = noti.userInfo
            let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            let y = LRSMessageToolBarHelper.screenHeight() - self.textViewHeight - LRSMessageToolBarHelper.safeAreaHeight()
            var rect = self.frame
            rect.origin.y = y
            frameChange(to: rect, duration: duration)
        }
    }

    func frameChange(to: CGRect, duration: TimeInterval? = 0.3) {
        UIView.animate(withDuration: duration!) {
            self.frame = to
        }
    }


    func sendMessage() {
        let str = toolBar.inputTextView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        delegate?.messageToolBarDidClickedReturn(bar: self, text: str)
        toolBar.inputTextView.text = ""
        toolBar.inputTextView.setContentOffset(.zero, animated: true)
        toolBar.inputTextView.resignFirstResponder()
    }
}

//    #pragma mark - UITextViewDelegate
//

//    #pragma mark - UIKeyboardNotification
//
//    - (void)keyboardWillChangeFrame:(NSNotification *)notification {
//        if (self.hidden) {
//            return;
//        }
//        NSDictionary *userInfo = notification.userInfo;
//        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGPoint centerEndPoint = [userInfo[UIKeyboardCenterEndUserInfoKey] CGPointValue];
//        CGRect beginFrame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, endFrame.size.width, endFrame.size.height);
//        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//
//        [UIView animateWithDuration:duration
//                              delay:0.0f
//                            options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState)
//                         animations:^{
//    //                         [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
//                             if (centerEndPoint.y > [LRSMessageToolBarHelper screenHeight] + 20) {
//    //                             [self willShowBottomView:nil];
//                             }
//                         } completion:nil];
//    }
//
//    - (void)didClickFaceBtn:(UIButton *)button {
//        NSLog(@"点击表情");
//
//    }
//
//    // 点击转换按钮,控制模式转换
//    - (void)msgSendClick:(UIButton *)btn {
//
//    }
//
//    - (void)onImagePickButtonClick:(UIButton *)button {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolBar:buttonDidClicked:)]) {
//            [self.delegate messageToolBar:self buttonDidClicked:1];
//        }
//    }
//    //
//    //#pragma mark - change frame
//    //
//    //- (void)willShowBottomHeight:(CGFloat)tobe_bottomHeight {
//    //    if ((self.toolBarSkinType == RecreationRoomChatToolBarType || self.toolBarSkinType == RecreationRoomAccompyChatToolBarType)) {
//    //        CGRect fromFrame = self.frame;
//    //        CGFloat bottomHeight = (tobe_bottomHeight == 0) ? kSafeAreaBottomHeight : tobe_bottomHeight;
//    //        CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
//    //        CGRect toFrame = CGRectMake(fromFrame.origin.x, SCREEN_HEIGHT - toHeight, fromFrame.size.width, toHeight);
//    //        if (tobe_bottomHeight == 0) {
//    //            bottomHeight = 0;
//    //            toFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, toHeight);
//    //        }
//    //
//    //        //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
//    //        if (tobe_bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height) {
//    //            return;
//    //        }
//    //
//    //        if (self.isHidden) {
//    //        } else {
//    //            self.frame = toFrame;
//    //            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
//    //                [_delegate didChangeFrameToHeight:toHeight];
//    //            }
//    //        }
//    //    } else {
//    //        CGRect fromFrame = self.frame;
//    //        CGFloat bottomHeight = (tobe_bottomHeight == 0) ? 0 + kSafeAreaBottomHeight : tobe_bottomHeight;
//    //        CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
//    //        CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
//    //
//    //        //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
//    //        if (tobe_bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height) {
//    //            return;
//    //        }
//    //
//    //        if (self.isHidden) {
//    //        } else {
//    //            self.frame = toFrame;
//    //            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
//    //                [_delegate didChangeFrameToHeight:toHeight];
//    //            }
//    //        }
//    //    }
//    //}
//    //
//    //- (void)willShowBottomView:(UIView *)bottomView {
//    //    if (![self.activityBottomView isEqual:bottomView]) {
//    //        if (self.activityBottomView) {
//    //            [self.activityBottomView removeFromSuperview];
//    //        }
//    //        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
//    //        [self willShowBottomHeight:bottomHeight];
//    //        if (bottomView) {
//    //            CGRect rect = bottomView.frame;
//    //            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
//    //            bottomView.frame = rect;
//    //            [self addSubview:bottomView];
//    //        } else {
//    //
//    //        }
//    //        self.activityBottomView = bottomView;
//    //    }
//    //}
//    //
//    //- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame {
//    //    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
//    //        //一定要把self.activityBottomView置为空
//    //        [self willShowBottomHeight:toFrame.size.height];
//    //        if (self.activityBottomView) {
//    //            [self.activityBottomView removeFromSuperview];
//    //        }
//    //        self.activityBottomView = nil;
//    //    } else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
//    //        [self willShowBottomHeight:0];
//    //    } else {
//    //        [self willShowBottomHeight:toFrame.size.height];
//    //    }
//    //}
//    //
//    //- (void)willShowInputTextViewToHeight:(CGFloat)toHeight {
//    //    if (toHeight < self.kInputTextViewMinHeight) {
//    //        toHeight = self.kInputTextViewMinHeight;
//    //    }
//    //    if (toHeight > self.maxTextInputViewHeight) {
//    //        toHeight = self.maxTextInputViewHeight;
//    //    }
//    //
//    //    if (toHeight == self.previousTextViewContentHeight) {
//    //        return;
//    //    } else {
//    //        CGFloat changeHeight = toHeight - self.previousTextViewContentHeight;
//    //
//    //        CGRect rect = self.frame;
//    //        rect.size.height += changeHeight;
//    //        rect.origin.y -= changeHeight;
//    //        self.frame = rect;
//    //
//    //        rect = self.toolbarView.frame;
//    //        rect.size.height += changeHeight;
//    //        self.toolbarView.frame = rect;
//    //        self.previousTextViewContentHeight = toHeight;
//    //
//    //        rect = self.contentView.frame;
//    //        rect.size.height += changeHeight;
//    //        self.contentView.frame = rect;
//    //
//    //        rect = self.inputBaseView.frame;
//    //        rect.size.height += changeHeight;
//    //        self.inputBaseView.frame = rect;
//    //
//    //        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)] && !self.isHidden) {
//    //            [_delegate didChangeFrameToHeight:self.frame.size.height];
//    //        }
//    //    }
//    //}
//    //
//    //
//    //#pragma mark - public
//    //
//    ///**
//    // *  停止编辑
//    // */
//    //- (BOOL)endEditing:(BOOL)force {
//    //    if (!force && (self.hidden || !self.inputTextView.isFirstResponder)) {
//    //        return YES;
//    //    } else {
//    //        BOOL result = [super endEditing:force];
//    //        self.faceButton.selected = NO;
//    //        [self.inputTextView endEditing:YES];
//    //        if ([self.inputTextView isFirstResponder] && [self.inputTextView canResignFirstResponder]) {
//    //            [self.inputTextView resignFirstResponder];
//    //        } else {
//    //            if (self.inputView.isFirstResponder) {
//    //                [self.inputTextView resignFirstResponder];
//    //            }
//    //        }
//    //        [self willShowBottomView:nil];
//    //        return result;
//    //    }
//    //}
//
//    - (LRSMemePackagesView *)memePackagesView {
//        if (!_memePackagesView) {
//            _memePackagesView = [[LRSMemePackagesView alloc] initWithFrame:CGRectZero configures:[LRSMessageToolBarHelper allEmojis]];
//            __weak typeof(self) weakSelf = self;
//            _memePackagesView.itemHandler = ^(LRSMemeSinglePage *view, LRSMemePackageConfigureItem *item) {
//                NSString *chatText = weakSelf.toolBar.inputTextView.text;
//                weakSelf.toolBar.inputTextView.text = [NSString stringWithFormat:@"%@%@", chatText ?: @"", item.emojiValue];
//                [weakSelf textViewDidChange:weakSelf.toolBar.inputTextView];
//            };
//            _memePackagesView.backspaceHandler = ^(LRSMemeSinglePage *view) {
//                [weakSelf.toolBar.inputTextView deleteBackward];
//            };
//            _memePackagesView.sendOutHandler = ^(LRSMemePackgaesView *view) {
//                [weakSelf sendOut_];
//            };
//        }
//        return _memePackagesView;
//    }
//
//    - (LRSMessageInputBar *)toolBar {
//        if (!_toolBar) {
//            _toolBar = [LRSMessageInputBar toolBarWithConfigure:self.configure];
//            _toolBar.backgroundColor = [UIColor whiteColor];
//            _toolBar.layer.shadowColor = [[UIColor blackColor] CGColor];
//            _toolBar.layer.shadowOffset = CGSizeMake(0, -2 * [LRSMessageToolBarHelper scale]);
//            _toolBar.layer.shadowRadius = 5.0 * [LRSMessageToolBarHelper scale];
//            _toolBar.layer.shadowOpacity = 0.1;
//            _toolBar.inputTextView.delegate = self;
//            __weak typeof(self) weakSelf = self;
//            _toolBar.recordingBtn.touchBegan = ^(LRSMessageToolBarRecordButton *button) {
//                NSLog(@"按下按钮,开始录音");
//                micphonePerPermission_ = [self.datasource audioPermission];
//                if (!micphonePerPermission_) {
//                    weakSelf.toolBar.recordingBtn.selected = false;
//                    return;
//                }
//                if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(messageToolBarBeganToSpeak:)]) {
//                    [weakSelf.delegate messageToolBarBeganToSpeak:weakSelf];
//                }
//            };
//            _toolBar.recordingBtn.touchEnd = ^(LRSMessageToolBarRecordButton *button) {
//                NSLog(@"结束录音");
//                if ([weakSelf.delegate respondsToSelector:@selector(messageToolBarEndSpeaking:)]) {
//                    [weakSelf.delegate messageToolBarEndSpeaking:weakSelf];
//                }
//            };
//            _toolBar.recordingBtn.dragEnter = ^(LRSMessageToolBarRecordButton *button) {
//                NSLog(@"区域划入");
//                if ([weakSelf.delegate respondsToSelector:@selector(messageToolBarDragEnterRecordScope)]) {
//                    [weakSelf.delegate messageToolBarDragEnterRecordScope:weakSelf];
//                }
//            };
//            _toolBar.recordingBtn.dragOutside = ^(LRSMessageToolBarRecordButton *button) {
//                NSLog(@"区域划出");
//                if ([weakSelf.delegate respondsToSelector:@selector(messageToolBarDragOutRecordScope)]) {
//                    [weakSelf.delegate messageToolBarDragOutRecordScope:weakSelf];
//                }
//            };
//            _toolBar.recordingBtn.dragOutsideRelease = ^(LRSMessageToolBarRecordButton *button) {
//                NSLog(@"区域划出松手");
//                if ([weakSelf.delegate respondsToSelector:@selector(messageToolBarSlideTopToCancelRecording:)]) {
//                    [weakSelf.delegate messageToolBarSlideTopToCancelRecording:weakSelf];
//                }
//            };
//        }
//        return _toolBar;
//    }


extension LRSMessageBar: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.messageToolBarInputTextViewDidBeginEditing?(bar: self)
    }

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.messageToolBarShouldBeginEditting(bar: self) ?? true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.messageToolBarInputTextViewDidEndEditing(bar: self)
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
        guard textView.text.count < length else {
            return
        }
        textView.text = String(textView.text.prefix(length))
        // height
    }

}
