//
//  LRSMessageToolBarEmojiConfigureItem.h
//  LRSMessageToolBar
//
//  Created by sama liu on 2021-11-1
//  Copyright (c) 2021年 sama liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRSMemePackageConfigureItem;
@interface LRSMemePackageConfigure : NSObject
@property (nonatomic, strong) NSArray<LRSMemePackageConfigureItem *> *emojis;
@property (nonatomic, copy) NSString *coverImageName;
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;
@property (nonatomic, copy) NSString *key;
@end

@interface LRSMemePackageConfigureItem : NSObject
@property (nonatomic, copy) NSString *emojiValue;
@end
