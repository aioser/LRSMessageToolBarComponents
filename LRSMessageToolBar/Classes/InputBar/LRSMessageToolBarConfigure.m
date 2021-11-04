//
//  LRSMessageToolBarConfigure.m
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#import "LRSMessageToolBarConfigure.h"
#import "LRSMessageToolBarHelper.h"

@interface LRSMessageToolBarConfigure()
@property (nonatomic, strong, readwrite) LRSMessageToolBarRecordButtonConfigure *recordConfigure;
@property (nonatomic, strong, readwrite) LRSMessageToolBarInputTextViewConfigure *textViewConfigure;
@property (nonatomic, strong, readwrite) LRSMessageToolBarActionButtonConfigure *buttonConfigure;
@property (nonatomic, strong, readwrite) LRSMessageToolBarModeSwitchButtonConfigure *modeSwitchConfigure;
@end

@implementation LRSMessageToolBarConfigure

- (instancetype)init {
    if (self = [super init]) {
        self.recordConfigure = [LRSMessageToolBarRecordButtonConfigure new];
        self.textViewConfigure = [LRSMessageToolBarInputTextViewConfigure new];
        self.buttonConfigure = [LRSMessageToolBarActionButtonConfigure new];
        self.modeSwitchConfigure = [LRSMessageToolBarModeSwitchButtonConfigure new];
    }
    return self;
}

@end


@implementation LRSMessageToolBarRecordButtonConfigure

- (LRSMessageToolBarButtonStateConfigure *)stateConfigure {
    if (!_stateConfigure) {
        _stateConfigure = [[LRSMessageToolBarButtonStateConfigure alloc] init];
        [_stateConfigure setImage:[LRSMessageToolBarHelper imageNamed:@"bt_im_voice"] forState:(UIControlStateNormal)];
        [_stateConfigure setImage:[LRSMessageToolBarHelper imageNamed:@"bt_im_voice_p"] forState:(UIControlStateSelected)];

        NSDictionary *titleAttribute = @{
            NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
            NSForegroundColorAttributeName: [UIColor blackColor],
        };
        [_stateConfigure setTitle:[[NSAttributedString alloc] initWithString:@"按住 说话" attributes:titleAttribute] forState:(UIControlStateNormal)];
        [_stateConfigure setTitle:[[NSAttributedString alloc] initWithString:@"松开 结束" attributes:titleAttribute] forState:(UIControlStateSelected)];
    }
    return _stateConfigure;
}

@end


@implementation LRSMessageToolBarInputTextViewConfigure

- (CGFloat)leftMargin {
    return 8;
}

- (CGFloat)topMargin {
    return 6;
}

- (NSInteger)acceptLength {
    return 200;
}

- (NSString *)placeholder {
    return @"输入聊天内容...";
}

- (CGFloat)maxHeight {
    return 88;
}

- (CGFloat)minHeight {
    return 33;
}
@end

@implementation LRSMessageToolBarModeSwitchButtonConfigure

- (CGFloat)leftMargin {
    return 8;
}

- (CGSize)buttonSize {
    return CGSizeMake(33, 33);
}

- (LRSMessageToolBarButtonStateConfigure *)stateConfigure {
    if (!_stateConfigure) {
        _stateConfigure = [[LRSMessageToolBarButtonStateConfigure alloc] init];
        [_stateConfigure setImage:[LRSMessageToolBarHelper imageNamed:@"information_keyboard_normal"] forState:(UIControlStateNormal)];
        [_stateConfigure setImage:[LRSMessageToolBarHelper imageNamed:@"im_voice_selected"] forState:(UIControlStateSelected)];
    }
    return _stateConfigure;
}
@end

@implementation LRSMessageToolBarActionButtonConfigure

- (CGFloat)rightButtonsMargin {
    return 9;
}

- (CGFloat)rightButtonsXSpacing {
    return 0;
}

- (CGSize)buttonSize {
    return CGSizeMake(33, 33);;
}

- (LRSMessageToolBarButtonStateConfigure *)emojiButtonStateConfigure {
    if (!_emojiButtonStateConfigure) {
        _emojiButtonStateConfigure = [[LRSMessageToolBarButtonStateConfigure alloc] init];
        [_emojiButtonStateConfigure setImage:[LRSMessageToolBarHelper imageNamed:@"information_expression_normal"] forState:(UIControlStateNormal)];
        [_emojiButtonStateConfigure setImage:[LRSMessageToolBarHelper imageNamed:@"information_expression_selected"] forState:(UIControlStateSelected)];
    }
    return _emojiButtonStateConfigure;
}

- (LRSMessageToolBarButtonStateConfigure *)imagePickerButtonStateConfigure {
    if (!_imagePickerButtonStateConfigure) {
        _imagePickerButtonStateConfigure = [[LRSMessageToolBarButtonStateConfigure alloc] init];
        [_imagePickerButtonStateConfigure setImage:[LRSMessageToolBarHelper imageNamed:@"im_pic"] forState:(UIControlStateNormal)];
        [_imagePickerButtonStateConfigure setImage:[LRSMessageToolBarHelper imageNamed:@"im_pic_selected"] forState:(UIControlStateNormal)];
    }
    return _imagePickerButtonStateConfigure;
}

@end

@interface LRSMessageToolBarButtonStateConfigure()
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *values;
@end

@implementation LRSMessageToolBarButtonStateConfigure

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    self.values[[NSString stringWithFormat:@"image_for_state_%@", @(state)]] = image;
}

- (UIImage *)imageForState:(UIControlState)state {
    return self.values[[NSString stringWithFormat:@"image_for_state_%@", @(state)]];
}

- (void)setTitle:(NSAttributedString *)title forState:(UIControlState)state {
    self.values[[NSString stringWithFormat:@"title_for_state_%@", @(state)]] = title;
}

- (NSAttributedString *)titleForState:(UIControlState)state {
    return self.values[[NSString stringWithFormat:@"title_for_state_%@", @(state)]];
}

- (NSMutableDictionary<NSString *, id> *)values {
    if (!_values) {
        _values = [NSMutableDictionary dictionary];
    }
    return _values;
}
@end
