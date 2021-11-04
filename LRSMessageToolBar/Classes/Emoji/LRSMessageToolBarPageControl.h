//
//  DDPageControl.h
//  DDPageControl
//
//  Created by Damien DeVille on 1/14/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKitDefines.h>

typedef NS_ENUM(NSUInteger, LRSMessageToolBarPageControlType) {
    LRSMessageToolBarPageControlTypeFullOffFull = 0,
    LRSMessageToolBarPageControlTypeFullOffEmpty = 1,
    LRSMessageToolBarPageControlTypeEmptyOffFull = 2,
    LRSMessageToolBarPageControlTypeEmptyOffEmpty = 3,
};

@interface LRSMessageToolBarPageControl : UIControl {
    NSInteger numberOfPages;
    NSInteger currentPage;
}

- (instancetype)initWithType:(LRSMessageToolBarPageControlType)theType;

@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL hidesForSinglePage;

@property (nonatomic) BOOL defersCurrentPageDisplay;
- (void)updateCurrentPageDisplay;

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@property (nonatomic) LRSMessageToolBarPageControlType type;

@property (nonatomic, strong) UIColor *onColor;
@property (nonatomic, strong) UIColor *offColor;

@property (nonatomic) CGFloat indicatorDiameter;
@property (nonatomic) CGFloat indicatorSpace;

@end
