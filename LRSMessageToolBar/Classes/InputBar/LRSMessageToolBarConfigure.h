//
//  LRSMessageToolBarConfigure.h
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#import <Foundation/Foundation.h>

@class LRSMessageToolBarRecordButtonConfigure;
@class LRSMessageToolBarInputTextViewConfigure;
@class LRSMessageToolBarActionButtonConfigure;
@class LRSMessageToolBarModeSwitchButtonConfigure;
@class LRSMessageToolBarButtonStateConfigure;
NS_ASSUME_NONNULL_BEGIN

@interface LRSMessageToolBarConfigure : NSObject
@property (nonatomic, strong, readonly) LRSMessageToolBarRecordButtonConfigure *recordConfigure;
@property (nonatomic, strong, readonly) LRSMessageToolBarInputTextViewConfigure *textViewConfigure;
@property (nonatomic, strong, readonly) LRSMessageToolBarActionButtonConfigure *buttonConfigure;
@property (nonatomic, strong, readonly) LRSMessageToolBarModeSwitchButtonConfigure *modeSwitchConfigure;
@end

@interface LRSMessageToolBarRecordButtonConfigure : NSObject
@property (nonatomic, strong) LRSMessageToolBarButtonStateConfigure *stateConfigure;
@end

@interface LRSMessageToolBarInputTextViewConfigure : NSObject
@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat topMargin;
@property (nonatomic) NSInteger acceptLength;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat minHeight;
@end

@interface LRSMessageToolBarModeSwitchButtonConfigure : NSObject
@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGSize buttonSize;
@property (nonatomic, strong) LRSMessageToolBarButtonStateConfigure *stateConfigure;
@end

@interface LRSMessageToolBarActionButtonConfigure : NSObject
@property (nonatomic) CGFloat rightButtonsMargin;
@property (nonatomic) CGFloat rightButtonsXSpacing;
@property (nonatomic) CGSize buttonSize;
@property (nonatomic, strong) LRSMessageToolBarButtonStateConfigure *emojiButtonStateConfigure;
@property (nonatomic, strong) LRSMessageToolBarButtonStateConfigure *imagePickerButtonStateConfigure;
@end

@interface LRSMessageToolBarButtonStateConfigure : NSObject
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (UIImage *)imageForState:(UIControlState)state;

- (void)setTitle:(NSAttributedString *)title forState:(UIControlState)state;
- (NSAttributedString *)titleForState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
