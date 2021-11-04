
#import "LRSMessageBar.h"
#import "LRSMessageToolBarHelper.h"
#import <MASonry/MASonry.h>
#import "LRSMessageToolsBar.h"

#define kMarkinSpace 15
#define kTextKeyBoard 200
#define kItemsToolH (kVerticalPadding * 2 + self.kInputTextViewMinHeight)

#define kNewHorizontalPadding ((self.toolBarSkinType == GameRoomChatToolBarType) ? 2 : 8)
#define kNewRightMargin 9
#define kNewFaceRightMagin ((self.toolBarSkinType == GameRoomChatToolBarType) ? 3 : 7)
#define kVerticalPadding ((self.toolBarSkinType == GameRoomChatToolBarType) ? 4.5 : 6)
#define kVerticalOffset ((self.toolBarSkinType == GameRoomChatToolBarType) ? 2.0 : 0)

#define kNewRecordHLBackColor RGBA(200, 200, 200, 1)

@interface LRSMessageBar () <UITextViewDelegate, LRSMessageToolBarEmojisViewDelegate> {
    BOOL micphonePerPermission_;
}
@property (nonatomic, strong) LRSMessageToolBarConfigure *configure;
@property (nonatomic, strong) LRSMessageToolsBar *toolBar;
@property (nonatomic, weak, nullable) LRSMessageToolBarEmojisContentView *faceView;
@end

@implementation LRSMessageBar

- (instancetype)initWithConfigure:(LRSMessageToolBarConfigure *)configure {
    if (self = [super init]) {
        self.configure = configure;
        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [self addSubview:self.toolBar];
}

- (LRSMessageToolsBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [LRSMessageToolsBar bar];
        _toolBar.backgroundColor = [UIColor whiteColor];
        _toolBar.layer.shadowColor = [[UIColor blackColor] CGColor];
        _toolBar.layer.shadowOffset = CGSizeMake(0, -2 * [LRSMessageToolBarHelper scale]);
        _toolBar.layer.shadowRadius = 5.0 * [LRSMessageToolBarHelper scale];
        _toolBar.layer.shadowOpacity = 0.1;
    }
    return _toolBar;
}
- (void)configureSubview {


//    @weakify(self);
//    [RACObserve(self.recordSwitchButton, selected) subscribeNext:^(NSNumber *isSelected) {
//        @strongify(self);
//        NSString *suffix = [isSelected boolValue] ? @"keyboard" : @"tel";
//        [self.recordSwitchButton setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@_normal", imageNamePrefix, suffix]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [self.recordSwitchButton setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@_selected", imageNamePrefix, suffix]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
//    }];


}

- (void)resetSubviewPostionWithInputViewShowOrHidden:(BOOL)show {
    if (show) {
        CGFloat width = SCREEN_WIDTH - (kNewHorizontalPadding * 4 + kNewRightMargin + self.kInputTextViewMinHeight * 3);
        CGRect baseRect = CGRectMake(self.kInputTextViewMinHeight + kNewHorizontalPadding * 2, kVerticalPadding + kVerticalOffset, width, self.kInputTextViewMinHeight);
        self.inputBaseView.frame = baseRect;
    } else {
        CGFloat width = SCREEN_WIDTH - (kNewHorizontalPadding * 3 + kNewRightMargin + self.kInputTextViewMinHeight * 2);
        CGRect baseRect = CGRectMake(self.kInputTextViewMinHeight + kNewHorizontalPadding * 2, kVerticalPadding + kVerticalOffset, width, self.kInputTextViewMinHeight);
        self.inputBaseView.frame = baseRect;
    }
    self.faceButton.hidden = !show;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextViewDidEndEditing:)]) {
        [self.delegate inputTextViewDidEndEditing:self.inputTextView];
    }

    [textView resignFirstResponder];
}


- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
        CGFloat caretY = MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
        if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
            textView.contentOffset = CGPointMake(0, caretY);
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        NSString *strUrl = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        if (strUrl.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:)]) {
                [self.delegate didSendText:textView.text];
                self.inputTextView.text = @"";
                CGFloat offset = self.inputTextView.contentSize.height - self.inputTextView.bounds.size.height;
                if (offset > 0) {
                    [self.inputTextView setContentOffset:CGPointMake(0, offset) animated:YES];
                }
            }
        } else {
            [ProgressHUD showErrorWithStatus:@"内容不能为空"];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *str = [NSString ignoreTalugu:textView.text];
    if (str != nil) {
        textView.text = str;
    }
    if ([DXMessageToolBarTextHandler textCountWithText:textView.text] > kTextKeyBoard) {
        textView.text = [DXMessageToolBarTextHandler handleTextWithText:textView.text maxLength:kTextKeyBoard];
    }
    [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];
}

- (void)sendEmojiImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:)]) {
        NSString *text = self.inputTextView.text;
        if (text.length != 0) {
            [self.delegate didSendText:text];
            self.inputTextView.text = nil;
        } else {
            [ProgressHUD showErrorWithStatus:@"内容不能为空"];
        }
    }
}

#pragma mark - 表情点击代理方法

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete {
    NSString *chatText = self.inputTextView.text;

    if (!isDelete) {
        self.inputTextView.text = [NSString stringWithFormat:@"%@%@", chatText ? : @"", str];
    } else {
        self.inputTextView.text = [DXMessageToolBarTextHandler deleteLastWordWithNow:self.inputTextView.text];
    }
    [self textViewDidChange:self.inputTextView];
}

- (void)sendFace {
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.inputTextView.text = @"";
        }
    }
}

//发送第三方表情

#pragma mark - UIKeyboardNotification
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (self.hidden) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGPoint centerEndPoint = [userInfo[UIKeyboardCenterEndUserInfoKey] CGPointValue];
    CGRect beginFrame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, endFrame.size.width, endFrame.size.height);
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//
//    if ((self.toolBarSkinType == RecreationRoomChatToolBarType || self.toolBarSkinType == RecreationRoomAccompyChatToolBarType || self.toolBarSkinType == PrivateChatToolBarType) && (self.recordSwitchButton.selected == NO)) {
//        if (k_IS_IPhoneX && endFrame.origin.y == SCREEN_HEIGHT) {
//            self.bottomLineView_X.hidden = NO;
//        } else {
//            self.bottomLineView_X.hidden = YES;
//        }
//    }

    @weakify(self);
    void (^animations)() = ^{
        @strongify(self)
            [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
        if (centerEndPoint.y > SCREEN_HEIGHT + 20) {
            [self willShowBottomView:nil];
        }
    };

    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:^(BOOL finished){

    }];
}

- (void)startRecording:(UIButton *)btn {
    NSLog(@"按下按钮,开始录音");
    if (self.delegate && [self.delegate respondsToSelector:@selector(beganToSpeak:)]) {
        micphonePerPermission_ = [self.delegate beganToSpeak:self];
        if (micphonePerPermission_) {
            if (self.toolBarSkinType == GameRoomChatToolBarType) {
                _recordingBtn.newsImgView.image = [UIImage imageNamed:@"im_words_selected"];
            } else if (self.toolBarSkinType == RecreationRoomChatToolBarType || self.toolBarSkinType == RecreationRoomAccompyChatToolBarType) {
                _recordingBtn.newsImgView.image = [UIImage imageNamed:@"voice_im_words_s"];
            } else {
                _recordingBtn.newsCallLabel.text = @"松开 结束";
                _recordingBtn.newsImgView.hidden = YES;
            }
        }
    }
    
}

- (void)endRecording:(UIButton *)btn {
    if (self.toolBarSkinType == GameRoomChatToolBarType) {
        _recordingBtn.newsImgView.image = [UIImage imageNamed:@"im_words"];
    } else if (self.toolBarSkinType == RecreationRoomChatToolBarType || self.toolBarSkinType == RecreationRoomAccompyChatToolBarType) {
        _recordingBtn.newsImgView.image = [UIImage imageNamed:@"voice_im_words"];
    } else {
        [self resetRecordBtnTitle];
    }
    NSLog(@"结束录音");
    if (self.delegate && [self.delegate respondsToSelector:@selector(endToSpeak:)]) {
        [self.delegate endToSpeak:self];
    }
}

- (void)cancelRecording:(UIButton *)btn {
    if (!micphonePerPermission_) {
        return;
    }
    if (self.toolBarSkinType == GameRoomChatToolBarType) {
        [self.recordingBtn setBackgroundImage:[[UIImage imageNamed:@"bt_room_im_words"] stretchableImageMultipliedBy:0.5] forState:(UIControlStateNormal)];
        [self.recordingBtn setBackgroundImage:[[UIImage imageNamed:@"bt_room_im_words_selected"] stretchableImageMultipliedBy:0.5] forState:(UIControlStateSelected)];
        _recordingBtn.newsImgView.image = [UIImage imageNamed:@"im_words"];
    } else if (self.toolBarSkinType == RecreationRoomChatToolBarType || self.toolBarSkinType == RecreationRoomAccompyChatToolBarType) {
        [self resetRecordBtnBackGroundImg];
        _recordingBtn.newsImgView.image = [UIImage imageNamed:@"voice_im_words"];
    } else {
        [self resetRecordBtnBackGroundImg];
        [self resetRecordBtnTitle];
    }
    // 上滑取消录音
    NSLog(@"取消录音");
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideTopToCancelRecordingWith:)]) {
        [self.delegate slideTopToCancelRecordingWith:self];
    }
}

- (void)dragEnterRecordScope:(UIButton *)btn {
    if (!micphonePerPermission_) {
        return;
    }
    [self resetRecordBtnBackGroundImg];
    // 划入按钮范围
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragEnterRecordScopeWith:)]) {
        [self.delegate dragEnterRecordScopeWith:self];
    }
}

- (void)dragExitRecordScope:(UIButton *)btn {
    if (!micphonePerPermission_) {
        return;
    }
    if (_toolBarSkinType == GameRoomChatToolBarType) {
    } else {
        [_recordingBtn setBackgroundImage:[UIImage imageWithColor:kNewRecordHLBackColor] forState:UIControlStateNormal];
    }
    // 划出按钮范围
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragExitRecordScopeWith:)]) {
        [self.delegate dragExitRecordScopeWith:self];
    }
}



// 还原录音按钮title显示
- (void)resetRecordBtnTitle {
    _recordingBtn.newsImgView.hidden = NO;
    _recordingBtn.newsCallLabel.text = @"按住 说话";
}

- (void)didClickFaceBtn:(UIButton *)button {
    NSLog(@"点击表情");
    button.selected = !button.selected;
    // 键盘隐藏,输入框显示,切换状态按钮为打电话按钮
    [self.inputTextView resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchEmojiViewShow:withMessageToolBar:)]) {
        [self.delegate onTouchEmojiViewShow:button.selected withMessageToolBar:self];
    }
    if (button.selected) {
        self.recordSwitchButton.selected = NO;
        [self willShowBottomView:self.faceView];
    } else {
        self.recordSwitchButton.selected = YES;
        [self willShowBottomView:nil];
    }
}

// 点击转换按钮,控制模式转换
- (void)msgSendClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    // iphoneX 底部线的显示
    if (k_IS_IPhoneX) {
        if ((self.toolBarSkinType == RecreationRoomChatToolBarType || self.toolBarSkinType == RecreationRoomAccompyChatToolBarType || self.toolBarSkinType == PrivateChatToolBarType)) {
            self.bottomLineView_X.hidden = btn.selected;
        } else {
            self.bottomLineView_X.hidden = false;
        }
    } else {
        self.bottomLineView_X.hidden = true;
    }
    self.inputBaseView.hidden = btn.selected;
    self.recordingBtn.hidden = !btn.selected;

    // 选中模式下btn图标
    if (btn.selected) {
        self.faceButton.selected = YES;
        [_inputTextView resignFirstResponder];
        [self willShowBottomView:nil];

        if (self.toolBarSkinType == RecreationRoomAccompyChatToolBarType || self.toolBarSkinType == GameRoomChatToolBarType) {
            self.multifunctionButton.hidden = YES;
            self.bigFaceButton.hidden = NO;
            [self.recordingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.inputBaseView);
                make.right.equalTo(self.bigFaceButton.mas_left).offset(-kNewHorizontalPadding);
            }];
            [self.bigFaceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-kNewHorizontalPadding));
                make.width.height.equalTo(@(self.kInputTextViewMinHeight));
                make.centerY.equalTo(self.inputBaseView);
            }];
        } else if (self.toolBarSkinType == RecreationRoomChatToolBarType) {
            self.multifunctionButton.hidden = YES;
            self.bigFaceButton.hidden = NO;
            [self.recordingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.inputBaseView);
                make.right.equalTo(self.bigFaceButton.mas_left).offset(-kNewHorizontalPadding);
            }];
            [self.multifunctionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-kNewHorizontalPadding));
                make.width.height.equalTo(@(self.kInputTextViewMinHeight));
                make.centerY.equalTo(self.inputBaseView);
            }];
            [self.bigFaceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.multifunctionButton.mas_left).offset(-kNewHorizontalPadding);
                make.width.height.equalTo(@(self.kInputTextViewMinHeight));
                make.centerY.equalTo(self.inputBaseView);
            }];
        }
    } else {
        self.faceButton.selected = NO;
        DDLogInfo(@"becomefirstResponder");
        [_inputTextView becomeFirstResponder];
        if (self.toolBarSkinType == RecreationRoomAccompyChatToolBarType || self.toolBarSkinType == GameRoomChatToolBarType) {
            [self.recordingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.inputBaseView);
            }];
            self.bigFaceButton.hidden = YES;
        } else if (self.toolBarSkinType == RecreationRoomChatToolBarType) {
            [self.recordingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.inputBaseView);
            }];
            self.multifunctionButton.hidden = YES;
            self.bigFaceButton.hidden = YES;
        }
    }
}

- (void)onImagePickButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DXMToolBarImagePickButtonAction:)]) {
        [self.delegate DXMToolBarImagePickButtonAction:self];
    }
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)tobe_bottomHeight {
    if ((self.toolBarSkinType == RecreationRoomChatToolBarType || self.toolBarSkinType == RecreationRoomAccompyChatToolBarType)) {
        CGRect fromFrame = self.frame;
        CGFloat bottomHeight = (tobe_bottomHeight == 0) ? kSafeAreaBottomHeight : tobe_bottomHeight;
        CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
        CGRect toFrame = CGRectMake(fromFrame.origin.x, SCREEN_HEIGHT - toHeight, fromFrame.size.width, toHeight);
        if (tobe_bottomHeight == 0) {
            bottomHeight = 0;
            toFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, toHeight);
        }

        //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
        if (tobe_bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height) {
            return;
        }

        if (self.isHidden) {
        } else {
            self.frame = toFrame;
            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                [_delegate didChangeFrameToHeight:toHeight];
            }
        }
    } else {
        CGRect fromFrame = self.frame;
        CGFloat bottomHeight = (tobe_bottomHeight == 0) ? 0 + kSafeAreaBottomHeight : tobe_bottomHeight;
        CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
        CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);

        //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
        if (tobe_bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height) {
            return;
        }

        if (self.isHidden) {
        } else {
            self.frame = toFrame;
            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                [_delegate didChangeFrameToHeight:toHeight];
            }
        }
    }
}

- (void)willShowBottomView:(UIView *)bottomView {
    if (![self.activityBottomView isEqual:bottomView]) {
        if (self.activityBottomView) {
            [self.activityBottomView removeFromSuperview];
        }
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        } else {
            
        }
        self.activityBottomView = bottomView;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame {
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        //一定要把self.activityBottomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityBottomView) {
            [self.activityBottomView removeFromSuperview];
        }
        self.activityBottomView = nil;
    } else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [self willShowBottomHeight:0];
    } else {
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight {
    if (toHeight < self.kInputTextViewMinHeight) {
        toHeight = self.kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }

    if (toHeight == self.previousTextViewContentHeight) {
        return;
    } else {
        CGFloat changeHeight = toHeight - self.previousTextViewContentHeight;

        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;

        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        self.previousTextViewContentHeight = toHeight;

        rect = self.contentView.frame;
        rect.size.height += changeHeight;
        self.contentView.frame = rect;

        rect = self.inputBaseView.frame;
        rect.size.height += changeHeight;
        self.inputBaseView.frame = rect;

        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)] && !self.isHidden) {
            [_delegate didChangeFrameToHeight:self.frame.size.height];
        }
    }
}



#pragma mark - public

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force {
    if (!force && (self.hidden || !self.inputTextView.isFirstResponder)) {
        return YES;
    } else {
        BOOL result = [super endEditing:force];
        self.faceButton.selected = NO;
        [self.inputTextView endEditing:YES];
        if ([self.inputTextView isFirstResponder] && [self.inputTextView canResignFirstResponder]) {
            [self.inputTextView resignFirstResponder];
        } else {
            if (self.inputView.isFirstResponder) {
                [self.inputTextView resignFirstResponder];
            }
        }
        [self willShowBottomView:nil];
        return result;
    }
}

- (void)setHidden:(BOOL)hidden {
    self.faceButton.selected = NO;
    [self.inputTextView endEditing:YES];
    if ([self.inputTextView isFirstResponder] && [self.inputTextView canResignFirstResponder]) {
        [self.inputTextView resignFirstResponder];
    } else {
        if (self.inputView.isFirstResponder) {
            [self.inputTextView resignFirstResponder];
        }
    }
    [super setHidden:hidden];
}

- (CGFloat)coolkeyboardHeight {
    return kItemsToolH + kSafeAreaBottomHeight;
}

- (void)showInputTextView {
    _inputTextView.hidden = NO;
}

- (void)hideInputTextView {
    [self willShowBottomView:nil];
    [self.inputTextView resignFirstResponder];
    _inputTextView.hidden = YES;
}

- (void)chatToolBarSkinType:(NSInteger)type {
    self.toolBarSkinType = type;
}


- (CGFloat)kInputTextViewMinHeight {
    if (_kInputTextViewMinHeight <= 0) {
        self.kInputTextViewMinHeight = 33;
    }
    return _kInputTextViewMinHeight;
}

- (CGFloat)kInputTextViewMaxHeight {
    if (_kInputTextViewMaxHeight <= 0) {
        _kInputTextViewMaxHeight = 88;
    }
    return _kInputTextViewMaxHeight;
}

#pragma mark - lazyload ----------


- (UIButton *)multifunctionButton {
    if (!_multifunctionButton) {
        _multifunctionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _multifunctionButton.backgroundColor = [UIColor clearColor];
        [_multifunctionButton addTarget:self action:@selector(multiFunctionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _multifunctionButton;
}

- (void)multiFunctionClick:(id)sender {
    [self.delegate popMutiFunction:sender];
}

- (LRSMessageToolBarEmojisContentView *)faceView {
    if (!_faceView) {
        _faceView = [[LRSMessageToolBarEmojisContentView alloc] init];
        _faceView.backgroundColor = [UIColor whiteColor];
        [_faceView setDelegate:self];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _faceView;
}

- (void)dealloc {
    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

@end
