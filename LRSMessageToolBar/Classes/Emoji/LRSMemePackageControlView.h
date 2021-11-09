//
//  EmojiKeyBoardView.h
//  EmojiKeyBoard
//
//  Created by Ayush on 09/05/13.
//  Copyright (c) 2013 Ayush. All rights reserved.
//
// Set as inputView to textfields, this view class gives an
// interface to the user to enter emoji characters.

#import <UIKit/UIKit.h>
#import "LRSMemePackageViewDefines.h"

@class LRSMemePackageConfigureItem;
NS_ASSUME_NONNULL_BEGIN
@interface LRSMemePackageControlView : UIView

- (instancetype)initWithEmojis:(NSArray<LRSMemePackageConfigureItem *> *)emojis row:(NSInteger)row column:(NSInteger)column;

@property (nonatomic, copy) LRSMemePackageItemsHandler itemHandler;
@property (nonatomic, copy) LRSMemePackageBackspaceHandler backspaceHandler;

- (void)buildUIWithTotalHeight:(CGFloat)memePackageBoardHeight;
@end
NS_ASSUME_NONNULL_END
