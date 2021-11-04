//
//  LRSMessageToolBarEmojiConfigureItem.h
//  LRSMessageToolBar
//
//  Created by sama liu on 2021-11-1
//  Copyright (c) 2021年 sama liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRSMemePackageViewDefines.h"

@class LRSMemePackageConfigureItem;

NS_ASSUME_NONNULL_BEGIN
@interface LRSMemeSinglePage : UIView

@property (nonatomic, copy) LRSMemePackageItemsHandler itemHandler;
@property (nonatomic, copy) LRSMemePackageBackspaceHandler backspaceHandler;

- (instancetype)initWithButtonSize:(CGSize)buttonSize
                              rows:(NSInteger)rows
                           columns:(NSInteger)columns
                          xSpacing:(CGFloat)xSpacing
                          ySpacing:(CGFloat)ySpacing;


- (void)setButtonEmojis:(NSArray<LRSMemePackageConfigureItem *> *)emojis;

@end

NS_ASSUME_NONNULL_END
