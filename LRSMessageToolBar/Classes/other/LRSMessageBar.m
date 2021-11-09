
#import "LRSMessageBar.h"
#import "LRSMessageToolBarHelper.h"
#import "LRSMessageInputBar.h"
#import "LRSMemePackagesView.h"
//#import "LRSMessageBar-swift.h"

@interface LRSMessageBar () <UITextViewDelegate> {
    BOOL micphonePerPermission_;
}
@property(nonatomic, strong) LRSMessageToolBarConfigure *configure;
@property(nonatomic, strong) LRSMessageInputBar *toolBar;
@property(nonatomic, strong, nullable) LRSMemePackagesView *memePackagesView;
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

- (void)sendOut_ {
    NSString *strUrl = [self.toolBar.inputTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    if (strUrl.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolBarDidClickedReturn:)]) {
            [self.delegate messageToolBarDidClickedReturn:self];
            self.toolBar.inputTextView.text = @"";
            [self.toolBar.inputTextView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    } else {
        [self.delegate messageToolBarDidClickedReturn:self];
    }
}

- (CGFloat)textViewContentHeight_:(UITextView *)textView {
    CGFloat height = ceilf((float) [textView sizeThatFits:textView.frame.size].height);
    CGFloat min = self.configure.textViewConfigure.minHeight;
    CGFloat max = self.configure.textViewConfigure.maxHeight;
    return MIN(max, MAX(min, height));
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolBarInputTextViewShouldBeginEditing)]) {
        return [self.delegate messageToolBarInputTextViewShouldBeginEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolBarInputTextViewDidBeginEditing:)]) {
        [self.delegate messageToolBarInputTextViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolBarInputTextViewDidEndEditing:)]) {
        [self.delegate messageToolBarInputTextViewDidEndEditing:self];
    }
    [textView resignFirstResponder];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY = MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
    if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendOut_];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger length = self.configure.textViewConfigure.acceptLength;
//    if ([DXMessageToolBarTextHandler textCountWithText:textView.text] > length) {
//        textView.text = [DXMessageToolBarTextHandler handleTextWithText:textView.text maxLength:length];
//    }
//    [self willShowInputTextViewToHeight:[self textViewContentHeight_:self.toolBar.inputTextView]];
}

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

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
//                         [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
                         if (centerEndPoint.y > [LRSMessageToolBarHelper screenHeight] + 20) {
//                             [self willShowBottomView:nil];
                         }
                     } completion:nil];
}

- (void)didClickFaceBtn:(UIButton *)button {
    NSLog(@"点击表情");

}

// 点击转换按钮,控制模式转换
- (void)msgSendClick:(UIButton *)btn {

}

- (void)onImagePickButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolBar:buttonDidClicked:)]) {
        [self.delegate messageToolBar:self buttonDidClicked:1];
    }
}
//
//#pragma mark - change frame
//
//- (void)willShowBottomHeight:(CGFloat)tobe_bottomHeight {
//    if ((self.toolBarSkinType == RecreationRoomChatToolBarType || self.toolBarSkinType == RecreationRoomAccompyChatToolBarType)) {
//        CGRect fromFrame = self.frame;
//        CGFloat bottomHeight = (tobe_bottomHeight == 0) ? kSafeAreaBottomHeight : tobe_bottomHeight;
//        CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
//        CGRect toFrame = CGRectMake(fromFrame.origin.x, SCREEN_HEIGHT - toHeight, fromFrame.size.width, toHeight);
//        if (tobe_bottomHeight == 0) {
//            bottomHeight = 0;
//            toFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, toHeight);
//        }
//
//        //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
//        if (tobe_bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height) {
//            return;
//        }
//
//        if (self.isHidden) {
//        } else {
//            self.frame = toFrame;
//            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
//                [_delegate didChangeFrameToHeight:toHeight];
//            }
//        }
//    } else {
//        CGRect fromFrame = self.frame;
//        CGFloat bottomHeight = (tobe_bottomHeight == 0) ? 0 + kSafeAreaBottomHeight : tobe_bottomHeight;
//        CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
//        CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
//
//        //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
//        if (tobe_bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height) {
//            return;
//        }
//
//        if (self.isHidden) {
//        } else {
//            self.frame = toFrame;
//            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
//                [_delegate didChangeFrameToHeight:toHeight];
//            }
//        }
//    }
//}
//
//- (void)willShowBottomView:(UIView *)bottomView {
//    if (![self.activityBottomView isEqual:bottomView]) {
//        if (self.activityBottomView) {
//            [self.activityBottomView removeFromSuperview];
//        }
//        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
//        [self willShowBottomHeight:bottomHeight];
//        if (bottomView) {
//            CGRect rect = bottomView.frame;
//            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
//            bottomView.frame = rect;
//            [self addSubview:bottomView];
//        } else {
//
//        }
//        self.activityBottomView = bottomView;
//    }
//}
//
//- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame {
//    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
//        //一定要把self.activityBottomView置为空
//        [self willShowBottomHeight:toFrame.size.height];
//        if (self.activityBottomView) {
//            [self.activityBottomView removeFromSuperview];
//        }
//        self.activityBottomView = nil;
//    } else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
//        [self willShowBottomHeight:0];
//    } else {
//        [self willShowBottomHeight:toFrame.size.height];
//    }
//}
//
//- (void)willShowInputTextViewToHeight:(CGFloat)toHeight {
//    if (toHeight < self.kInputTextViewMinHeight) {
//        toHeight = self.kInputTextViewMinHeight;
//    }
//    if (toHeight > self.maxTextInputViewHeight) {
//        toHeight = self.maxTextInputViewHeight;
//    }
//
//    if (toHeight == self.previousTextViewContentHeight) {
//        return;
//    } else {
//        CGFloat changeHeight = toHeight - self.previousTextViewContentHeight;
//
//        CGRect rect = self.frame;
//        rect.size.height += changeHeight;
//        rect.origin.y -= changeHeight;
//        self.frame = rect;
//
//        rect = self.toolbarView.frame;
//        rect.size.height += changeHeight;
//        self.toolbarView.frame = rect;
//        self.previousTextViewContentHeight = toHeight;
//
//        rect = self.contentView.frame;
//        rect.size.height += changeHeight;
//        self.contentView.frame = rect;
//
//        rect = self.inputBaseView.frame;
//        rect.size.height += changeHeight;
//        self.inputBaseView.frame = rect;
//
//        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)] && !self.isHidden) {
//            [_delegate didChangeFrameToHeight:self.frame.size.height];
//        }
//    }
//}
//
//
//#pragma mark - public
//
///**
// *  停止编辑
// */
//- (BOOL)endEditing:(BOOL)force {
//    if (!force && (self.hidden || !self.inputTextView.isFirstResponder)) {
//        return YES;
//    } else {
//        BOOL result = [super endEditing:force];
//        self.faceButton.selected = NO;
//        [self.inputTextView endEditing:YES];
//        if ([self.inputTextView isFirstResponder] && [self.inputTextView canResignFirstResponder]) {
//            [self.inputTextView resignFirstResponder];
//        } else {
//            if (self.inputView.isFirstResponder) {
//                [self.inputTextView resignFirstResponder];
//            }
//        }
//        [self willShowBottomView:nil];
//        return result;
//    }
//}

- (LRSMemePackagesView *)memePackagesView {
    if (!_memePackagesView) {
        _memePackagesView = [[LRSMemePackagesView alloc] initWithFrame:CGRectZero configures:[LRSMessageToolBarHelper allEmojis]];
        __weak typeof(self) weakSelf = self;
        _memePackagesView.itemHandler = ^(LRSMemeSinglePage *view, LRSMemePackageConfigureItem *item) {
            NSString *chatText = weakSelf.toolBar.inputTextView.text;
            weakSelf.toolBar.inputTextView.text = [NSString stringWithFormat:@"%@%@", chatText ?: @"", item.emojiValue];
            [weakSelf textViewDidChange:weakSelf.toolBar.inputTextView];
        };
        _memePackagesView.backspaceHandler = ^(LRSMemeSinglePage *view) {
            [weakSelf.toolBar.inputTextView deleteBackward];
        };
        _memePackagesView.sendOutHandler = ^(LRSMemePackgaesView *view) {
            [weakSelf sendOut_];
        };
    }
    return _memePackagesView;
}

- (LRSMessageInputBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [LRSMessageInputBar toolBarWithConfigure:self.configure];
        _toolBar.backgroundColor = [UIColor whiteColor];
        _toolBar.layer.shadowColor = [[UIColor blackColor] CGColor];
        _toolBar.layer.shadowOffset = CGSizeMake(0, -2 * [LRSMessageToolBarHelper scale]);
        _toolBar.layer.shadowRadius = 5.0 * [LRSMessageToolBarHelper scale];
        _toolBar.layer.shadowOpacity = 0.1;
        _toolBar.inputTextView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _toolBar.recordingBtn.touchBegan = ^(LRSMessageToolBarRecordButton *button) {
            NSLog(@"按下按钮,开始录音");
            micphonePerPermission_ = [self.datasource audioPermission];
            if (!micphonePerPermission_) {
                weakSelf.toolBar.recordingBtn.selected = false;
                return;
            }
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(messageToolBarBeganToSpeak:)]) {
                [weakSelf.delegate messageToolBarBeganToSpeak:weakSelf];
            }
        };
        _toolBar.recordingBtn.touchEnd = ^(LRSMessageToolBarRecordButton *button) {
            NSLog(@"结束录音");
            if ([weakSelf.delegate respondsToSelector:@selector(messageToolBarEndSpeaking:)]) {
                [weakSelf.delegate messageToolBarEndSpeaking:weakSelf];
            }
        };
        _toolBar.recordingBtn.dragEnter = ^(LRSMessageToolBarRecordButton *button) {
            NSLog(@"区域划入");
            if ([weakSelf.delegate respondsToSelector:@selector(messageToolBarDragEnterRecordScope)]) {
                [weakSelf.delegate messageToolBarDragEnterRecordScope:weakSelf];
            }
        };
        _toolBar.recordingBtn.dragOutside = ^(LRSMessageToolBarRecordButton *button) {
            NSLog(@"区域划出");
            if ([weakSelf.delegate respondsToSelector:@selector(messageToolBarDragOutRecordScope)]) {
                [weakSelf.delegate messageToolBarDragOutRecordScope:weakSelf];
            }
        };
        _toolBar.recordingBtn.dragOutsideRelease = ^(LRSMessageToolBarRecordButton *button) {
            NSLog(@"区域划出松手");
            if ([weakSelf.delegate respondsToSelector:@selector(messageToolBarSlideTopToCancelRecording:)]) {
                [weakSelf.delegate messageToolBarSlideTopToCancelRecording:weakSelf];
            }
        };
    }
    return _toolBar;
}

- (void)dealloc {

}

@end
