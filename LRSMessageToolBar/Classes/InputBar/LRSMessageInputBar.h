//
//  LRSMessageToolsBar.h
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#import <UIKit/UIKit.h>
#import "LRSPlaceholderTextView.h"
#import "LRSMessageToolBarRecordButton.h"

typedef NS_ENUM(NSUInteger, LRSMessageToolBarMode) {
    LRSMessageToolBarModeTextInput,
    LRSMessageToolBarModeRecord,
};

@class LRSMessageToolBarConfigure;

NS_ASSUME_NONNULL_BEGIN

@interface LRSMessageInputBar : UIView

+ (instancetype)toolBarWithConfigure:(LRSMessageToolBarConfigure *)configure;

@property (nonatomic) LRSMessageToolBarMode mode;
@property (nonatomic, strong) UIButton *modeSwitchButton;
@property (nonatomic, strong) LRSMessageToolBarRecordButton *recordingBtn;
@property (nonatomic, strong) LRSPlaceholderTextView *inputTextView;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *imagePickButton;
@property (nonatomic, strong) UIView *bottomLine;
@end

NS_ASSUME_NONNULL_END
