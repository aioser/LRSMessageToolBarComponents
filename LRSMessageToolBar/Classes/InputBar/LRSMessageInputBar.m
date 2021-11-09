//
//  LRSMessageToolsBar.m
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#import "LRSMessageInputBar.h"
#import <MASonry/MASonry.h>
#import "LRSMessageToolBarHelper.h"
#import "LRSMessageToolBarConfigure.h"

@interface LRSMessageInputBar()
@property (nonatomic, strong) LRSMessageToolBarConfigure *configure;
@property (nonatomic, strong) MASConstraint *textViewHeight;
@end

@implementation LRSMessageInputBar
@synthesize mode = _mode;

+ (instancetype)toolBarWithConfigure:(LRSMessageToolBarConfigure *)configure {
    LRSMessageInputBar *bar = [[self alloc] init];
    bar.configure = configure;
    [bar loadBasicSubviews];
    [bar configureSubviews];
    bar.mode = LRSMessageToolBarModeTextInput;
    return bar;
}

- (void)configureSubviews {
    [self.recordingBtn setBackgroundImage:[self.configure.recordConfigure.stateConfigure imageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.recordingBtn setBackgroundImage:[self.configure.recordConfigure.stateConfigure imageForState:UIControlStateSelected] forState:UIControlStateSelected];
    [self.recordingBtn setAttributedTitle:[self.configure.recordConfigure.stateConfigure titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.recordingBtn setAttributedTitle:[self.configure.recordConfigure.stateConfigure titleForState:UIControlStateSelected] forState:UIControlStateSelected];

    [self.imagePickButton setImage:[self.configure.buttonConfigure.imagePickerButtonStateConfigure imageForState:UIControlStateNormal] forState:(UIControlStateNormal)];

    [self.faceButton setImage:[self.configure.buttonConfigure.emojiButtonStateConfigure imageForState:UIControlStateNormal] forState:(UIControlStateNormal)];

    self.inputTextView.placeHolder = self.configure.textViewConfigure.placeholder;

    self.recordingBtn.areaY = self.configure.textViewConfigure.minHeight;

}

- (void)loadBasicSubviews {
    // 底部视图容器
    [self addSubview:self.imagePickButton];
    [self addSubview:self.faceButton];
    [self addSubview:self.inputTextView];
    [self addSubview:self.recordingBtn];
    [self addSubview:self.modeSwitchButton];
    [self addSubview:self.bottomLine];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.inputTextView.mas_bottom).offset(-1);
        make.left.right.equalTo(self.inputTextView);
        make.height.equalTo(@0.5);
    }];
    [self.modeSwitchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(self.configure.modeSwitchConfigure.leftMargin));
        make.size.mas_equalTo(self.configure.modeSwitchConfigure.buttonSize);
        make.centerY.equalTo(self.inputTextView);
    }];
    [self.recordingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.modeSwitchButton.mas_right).offset(self.configure.textViewConfigure.leftMargin);
        make.top.mas_equalTo(self.configure.textViewConfigure.topMargin);
        make.right.equalTo(self.imagePickButton.mas_left).offset(-self.configure.textViewConfigure.topMargin);
        make.height.mas_equalTo(self.configure.textViewConfigure.minHeight);
    }];
    [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.recordingBtn);
        make.right.equalTo(self.faceButton.mas_left).offset(-self.configure.textViewConfigure.topMargin);
        self.textViewHeight = make.height.mas_equalTo(self.configure.textViewConfigure.minHeight);
    }];
    [self.imagePickButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-self.configure.buttonConfigure.rightButtonsMargin);
        make.centerY.equalTo(self.modeSwitchButton);
        make.width.height.equalTo(self.modeSwitchButton);
    }];
    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.imagePickButton);
        make.centerY.equalTo(self.imagePickButton);
        make.right.equalTo(self.imagePickButton.mas_left).offset(self.configure.buttonConfigure.rightButtonsXSpacing);
    }];
}

- (void)setMode:(LRSMessageToolBarMode)mode {
    _mode = mode;
    [self onModeSwitch:mode];
}

- (void)modeSwitchClick:(UIButton *)button {
    self.mode = !_mode;
}

- (void)onModeSwitch:(LRSMessageToolBarMode)mode {
    self.recordingBtn.hidden = mode == LRSMessageToolBarModeTextInput;
    self.modeSwitchButton.selected = !self.recordingBtn.hidden;
    self.inputTextView.hidden = !self.recordingBtn.hidden;
    self.faceButton.hidden = self.inputTextView.hidden;
    [self.modeSwitchButton setBackgroundImage:[self.configure.modeSwitchConfigure.stateConfigure imageForState:mode == LRSMessageToolBarModeTextInput ? UIControlStateNormal : UIControlStateSelected] forState:UIControlStateNormal];

}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    }
    return _bottomLine;
}

- (LRSPlaceholderTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[LRSPlaceholderTextView alloc] initWithFrame:(CGRectZero)];
        _inputTextView.font = [UIFont systemFontOfSize:16];
        _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _inputTextView.scrollEnabled = YES;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.keyboardType = UIKeyboardTypeDefault;
        [_inputTextView.undoManager disableUndoRegistration];
    }
    return _inputTextView;
}

- (UIButton *)imagePickButton {
    if (!_imagePickButton) {
        self.imagePickButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [_imagePickButton addTarget:self action:@selector(onImagePickButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _imagePickButton;
}

- (UIButton *)modeSwitchButton {
    if (!_modeSwitchButton) {
        _modeSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modeSwitchButton addTarget:self action:@selector(modeSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeSwitchButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _faceButton.selected = NO;
        _faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
//        [_faceButton addTarget:self action:@selector(didClickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (LRSMessageToolBarRecordButton *)recordingBtn {
    if (!_recordingBtn) {
        _recordingBtn = [LRSMessageToolBarRecordButton buttonWithType:UIButtonTypeCustom];
        _recordingBtn.backgroundColor = [UIColor clearColor];
        _recordingBtn.layer.masksToBounds = YES;

        _recordingBtn.clickTime = 0;
        _recordingBtn.hidden = YES;
        _recordingBtn.selected = NO;
    }
    return _recordingBtn;
}


@end
