//
//  KeyboardRecordButton.h
//  LangRen
//
//  Created by 酒诗 on 2017/2/8.
//  Copyright © 2017年 langrengame.com. All rights reserved.
//

#import "IconTextButton.h"

@interface KeyboardRecordButton : IconTextButton

@property (nonatomic, copy) void (^touchBegan)();
@property (nonatomic, copy) void (^dragOutside)();
@property (nonatomic, copy) void (^dragEnter)();
@property (nonatomic, copy) void (^touchEnd)();
@property (nonatomic, copy) void (^dragOutsideRelease)();

@property (nonatomic, assign) CGFloat clickTime; //  设置长按时间
@property (nonatomic, strong, readonly) NSTimer *timer;
@property (nonatomic, assign, readonly) BOOL inArea; //  在区域内
@property (nonatomic, assign) int areaY;             //  设置识别高度

@end
