//
//  OC_Test.m
//  LRSMessageToolBar_Example
//
//  Created by sama 刘 on 2021/11/17.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "OC_Test.h"
#import <LRSMessageToolBarComponents/LRSMessageToolBarComponents-Swift.h>

@implementation OC_Test

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        LRSMessageBar *bar = [[LRSMessageBar alloc] initWithFrame:(CGRectZero) configure:[LRSMessageToolBarConfigure new]];
        bar.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
