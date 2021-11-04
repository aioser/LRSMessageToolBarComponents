//
//  KeyboardRecordButton.m
//  LangRen
//
//  Created by 酒诗 on 2017/2/8.
//  Copyright © 2017年 langrengame.com. All rights reserved.
//

#import "KeyboardRecordButton.h"

@interface KeyboardRecordButton ()

@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (nonatomic, assign, readwrite) BOOL inArea; //  在区域内

@end

@implementation KeyboardRecordButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    @weakify(self);
    [self.timer invalidate];
    NSTimer *timer = [NSTimer bk_scheduledTimerWithTimeInterval:self.clickTime block:^(NSTimer *timer) {
        @strongify(self);
        NSLog(@"Touch Began");
        if (self.touchBegan) {
            self.touchBegan();
        }
        [timer invalidate];
        self.timer = nil;
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.inArea = YES;
    self.timer = timer;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.timer) {
        return;
    }
    UITouch *anchTouch = [touches anyObject];
    CGPoint point = [anchTouch locationInView:self];
    BOOL isInArea = (point.y >= 0 && point.y <= self.areaY);
    if (self.inArea != isInArea) {
        if (self.inArea) {
            if (self.dragOutside) {
                NSLog(@"Drag Outside");
                self.dragOutside();
            }
        } else {
            if (self.dragEnter) {
                NSLog(@"Drag Enter");
                self.dragEnter();
            }
        }
        self.inArea = isInArea;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    if (self.inArea) {
        NSLog(@"Touch End");
        if (self.touchEnd) {
            self.touchEnd();
        }
    } else {
        NSLog(@"Drag Outside Release");
        if (self.dragOutsideRelease) {
            self.dragOutsideRelease();
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    NSLog(@"Touch Cancell");
    if (self.touchEnd) {
        self.touchEnd();
    }
}

- (void)dealloc {
    
}

@end
