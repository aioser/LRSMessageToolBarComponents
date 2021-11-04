//
//  EmojiKeyBoardView.m
//  EmojiKeyBoard
//
//  Created by Ayush on 09/05/13.
//  Copyright (c) 2013 Ayush. All rights reserved.
//

#import "LRSMemePackageControlView.h"
#import "LRSMemeSinglePage.h"
#import "LRSMessageToolBarPageControl.h"
#import "LRSMemePackageConfigure.h"
#import "LRSMessageToolBarHelper.h"
#import <MASonry/MASonry.h>

#define PAGE_CONTROL_INDICATOR_DIAMETER 6.0

@interface LRSMemePackageControlView () <UIScrollViewDelegate>
@property (nonatomic) NSInteger columns;
@property (nonatomic) NSInteger rows;
@property (nonatomic, strong) LRSMessageToolBarPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<LRSMemePackageConfigureItem *> *configures;
@end

@implementation LRSMemePackageControlView

- (instancetype)initWithEmojis:(NSArray<LRSMemePackageConfigureItem *> *)emojis row:(NSInteger)row column:(NSInteger)column {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [LRSMessageToolBarHelper colorNamed:@"Color_250"];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.configures = emojis;
        self.rows = row;
        self.columns = column;
    }
    return self;
}

- (void)buildUIWithTotoalHeight:(CGFloat)controlBoardHeight {
    NSInteger row = self.rows;
    NSInteger column = self.columns;
    NSArray<LRSMemePackageConfigureItem *> *emojis = self.configures;
    NSInteger count = MAX(row * column - 1, 0);
    NSInteger page = emojis.count / count;
    if (emojis.count % count == 0) {

    } else {
        page += 1;
    }
    self.pageControl.numberOfPages = page;
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:page];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.size.mas_equalTo(pageControlSize);
        make.centerX.equalTo(self);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.pageControl.mas_top);
    }];

    UIView *contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
    }];

    NSMutableArray<NSArray<LRSMemePackageConfigureItem *> *> *lists = [NSMutableArray arrayWithCapacity:page];
    NSMutableArray<LRSMemePackageConfigureItem *> *items = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger index = 0; index < emojis.count; ++ index) {
        LRSMemePackageConfigureItem *item = emojis[index];
        [items addObject:item];
        if (items.count == count || index == emojis.count - 1) {
            [lists addObject:items.copy];
            [items removeAllObjects];
        }
    }

    CGSize itemSize = [LRSMessageToolBarHelper sizeForEmojiKey:@"default"];
    CGFloat xSpacing = ([self viewWidth] - column * itemSize.width - (self.scrollViewEdgeInsets.left + self.scrollViewEdgeInsets.right)) / (column - 1);
    CGFloat memePackageBoardHeight = controlBoardHeight - pageControlSize.height - (self.scrollViewEdgeInsets.top + self.scrollViewEdgeInsets.bottom);
    CGFloat ySpacing = (memePackageBoardHeight - row * itemSize.height) / (row - 1);
    for (NSInteger index = 0; index < lists.count; ++ index) {
        NSArray<LRSMemePackageConfigureItem *> *emojis = lists[index];
        LRSMemeSinglePage *page = [[LRSMemeSinglePage alloc] initWithButtonSize:itemSize rows:row columns:column xSpacing:xSpacing ySpacing:ySpacing];
        [contentView addSubview:page];
        page.itemHandler = self.itemHandler;
        page.backspaceHandler = self.backspaceHandler;
        [page setButtonEmojis:emojis];
        [page mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(index * [self viewWidth] + self.scrollViewEdgeInsets.left);
            make.top.equalTo(contentView).offset(self.scrollViewEdgeInsets.top);
            make.bottom.equalTo(contentView).offset(-self.scrollViewEdgeInsets.bottom);
            make.width.mas_equalTo([self viewWidth] - (self.scrollViewEdgeInsets.left + self.scrollViewEdgeInsets.right));
            if (index == lists.count - 1) {
                make.right.equalTo(contentView);
            }
            make.height.mas_equalTo(memePackageBoardHeight);
        }];
    }
}


- (CGFloat)viewWidth {
    return [LRSMessageToolBarHelper screenWidth];
}

- (UIEdgeInsets)scrollViewEdgeInsets {
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (void)dealloc {
    self.pageControl = nil;
    self.scrollView = nil;
}

#pragma mark event handlers

- (void)pageControlTouched:(LRSMessageToolBarPageControl *)sender {
    [self.scrollView setContentOffset:CGPointMake([self viewWidth] * sender.currentPage, 0) animated:false];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%.2f", scrollView.contentOffset.x);
    NSInteger newPageNumber = (NSInteger)scrollView.contentOffset.x / ([self viewWidth] - (self.scrollViewEdgeInsets.left + self.scrollViewEdgeInsets.right));
    if (self.pageControl.currentPage == newPageNumber) {
        return;
    }
    self.pageControl.currentPage = newPageNumber;
}

#pragma mark EmojiPageViewDelegate

- (LRSMessageToolBarPageControl *)pageControl {
    if (!_pageControl) {
        LRSMessageToolBarPageControl *pageControl = [[LRSMessageToolBarPageControl alloc] initWithType:LRSMessageToolBarPageControlTypeFullOffFull];
        pageControl.onColor = [UIColor blackColor];
        pageControl.offColor = [LRSMessageToolBarHelper colorNamed:@"Color_192"];
        pageControl.indicatorDiameter = PAGE_CONTROL_INDICATOR_DIAMETER;
        pageControl.hidesForSinglePage = YES;
        pageControl.currentPage = 0;
        [pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventValueChanged];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        _scrollView = scrollView;
    }
    return _scrollView;
}
@end
