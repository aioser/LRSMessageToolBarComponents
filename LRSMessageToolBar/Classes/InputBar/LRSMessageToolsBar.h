//
//  LRSMessageToolsBar.h
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#import <UIKit/UIKit.h>
#import "LRSMessageToolBarEmojisContentView.h"
#import "XHMessageTextView.h"
#import "KeyboardRecordButton.h"

typedef NS_ENUM(NSUInteger, LRSMessageToolBarMode) {
    LRSMessageToolBarModeTextInput,
    LRSMessageToolBarModeRecord,
};

@class LRSMessageToolBarConfigure;

NS_ASSUME_NONNULL_BEGIN

@interface LRSMessageToolsBar : UIView

+ (instancetype)toolBarWithConfigure:(LRSMessageToolBarConfigure *)configure;

@property (nonatomic) LRSMessageToolBarMode mode;
@property (nonatomic, assign) CGFloat previousTextViewContentHeight; // 上一次inputTextView的contentSize.height
@property (nonatomic, strong) UIButton *modeSwitchButton;
@property (nonatomic, strong) KeyboardRecordButton *recordingBtn;
@property (nonatomic, strong) XHMessageTextView *inputTextView;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *imagePickButton;
@property (nonatomic, strong) UIView *bottomLine;
@end

NS_ASSUME_NONNULL_END
