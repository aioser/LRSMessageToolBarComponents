//
//  LRSMessageToolBarEmojiConfigureItem.h
//  LRSMessageToolBar
//
//  Created by sama liu on 2021-11-1
//  Copyright (c) 2021年 sama liu. All rights reserved.
//

#import "LRSMemeSinglePage.h"
#import "LRSMessageToolBarHelper.h"
#import "LRSMemePackageConfigure.h"
#import <MASonry/MASonry.h>

#define BACKSPACE_BUTTON_TAG 10
#define BUTTON_FONT_SIZE 32

@interface LRSMemeSinglePage ()
@property (nonatomic) CGSize buttonSize;
@property (nonatomic) CGFloat xSpacing;
@property (nonatomic) CGFloat ySpacing;
@property (nonatomic) NSInteger columns;
@property (nonatomic) NSInteger rows;
@property (nonatomic, strong) NSArray<LRSMemePackageConfigureItem *> *emojis;
@end

@implementation LRSMemeSinglePage

- (instancetype)initWithButtonSize:(CGSize)buttonSize
                              rows:(NSInteger)rows
                           columns:(NSInteger)columns
                          xSpacing:(CGFloat)xSpacing
                          ySpacing:(CGFloat)ySpacing {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.buttonSize = buttonSize;
        self.columns = columns;
        self.rows = rows;
        self.xSpacing = xSpacing;
        self.ySpacing = ySpacing;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _columns = 9;
        _rows = 4;
    }
    return self;
}

- (void)setButtonEmojis:(NSArray<LRSMemePackageConfigureItem *> *)emojis {
    self.emojis = emojis;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSUInteger index = 0; index < [self.emojis count]; ++index) {
        NSInteger row = (NSInteger)(index / self.columns);
        NSInteger column = (NSInteger)(index % self.columns);
        UIButton *button = [self buildButtonWithIndex:row column:column];
        button.titleLabel.font = [UIFont fontWithName:@"Apple color emoji" size:BUTTON_FONT_SIZE];
        button.tag = 100 + index;
        LRSMemePackageConfigureItem *info = [self.emojis objectAtIndex:index];
        [button setTitle:info.emojiValue forState:UIControlStateNormal];
    }
    //
    UIButton *button = [self buildButtonWithIndex:self.rows - 1 column:self.columns - 1];
    [button setImage:[LRSMessageToolBarHelper imageNamed:@"faceDelete"] forState:UIControlStateNormal];
    button.tag = BACKSPACE_BUTTON_TAG;
}

- (UIButton *)buildButtonWithIndex:(NSInteger)row column:(NSInteger)column {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(emojiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(column * (self.buttonSize.width + self.xSpacing));
        make.top.mas_equalTo(row * (self.buttonSize.height + self.ySpacing));
        make.size.mas_equalTo(self.buttonSize);
    }];
    return button;
}

- (void)emojiButtonPressed:(UIButton *)button {
    if (button.tag == BACKSPACE_BUTTON_TAG) {
        self.backspaceHandler(self);
        return;
    }

    NSInteger tag = button.tag - 100;
    if (tag >= 0 && tag < self.emojis.count) {
        LRSMemePackageConfigureItem *info = [self.emojis objectAtIndex:tag];
        self.itemHandler(self, info);
    }
}

- (void)dealloc {
    self.emojis = nil;
}

@end
