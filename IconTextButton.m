//
//  IconTextButton.m
//  WarnChat
//
//  Created by Apple on 16/4/25.
//  Copyright © 2016年 langrengame.com. All rights reserved.
//

#import "IconTextButton.h"

@implementation IconTextModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.whProportion = 1.0;
    }
    return self;
}

+ (instancetype) new {
    IconTextModel *model = [super new];
    model.whProportion = 1.0;
    return model;
}

@end

@implementation IconTextButton

- (void)setIconTextModel:(IconTextModel *)iconTextModel {
    _iconTextModel = iconTextModel;
    if (_iconTextModel) {
        [self removeAllSubviews];
        if (_iconTextModel.type == ICON_FRONT_TYPE) {
            [self layoutButtonViews];
        } else if (_iconTextModel.type == ICON_LAST_TYPE) {
            [self layoutlastIconButtonViews];
        }
    }
}

- (void)layoutButtonViews {
    UIView *contentView = [UIView new];
    contentView.userInteractionEnabled = NO;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(self);
    }];

    //通话按钮设置
    _newsImgView = [[UIImageView alloc] initWithImage:self.iconTextModel.iconImg];
    _newsImgView.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:_newsImgView];
    [_newsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(@0);
        make.width.equalTo(@(self.iconTextModel.iconW));
        make.height.equalTo(@(self.iconTextModel.iconW / self.iconTextModel.whProportion));
    }];

    // title
    _newsCallLabel = [UILabel new];
    _newsCallLabel.text = self.iconTextModel.labelText;
    _newsCallLabel.font = self.iconTextModel.font;
    [contentView addSubview:_newsCallLabel];
    [_newsCallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_newsImgView.mas_right).offset(self.iconTextModel.spaceWidth);
        make.top.equalTo(@(self.iconTextModel.topBottomMargin));
        make.bottom.equalTo(@(-self.iconTextModel.topBottomMargin));
        make.right.equalTo(contentView).offset(0);
    }];
}

- (void)layoutlastIconButtonViews {
    UIView *contentView = [UIView new];
    contentView.userInteractionEnabled = NO;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(self);
    }];

    //通话按钮设置
    _newsImgView = [[UIImageView alloc] initWithImage:self.iconTextModel.iconImg];
    _newsImgView.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:_newsImgView];

    [_newsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.iconTextModel.iconW));
        make.top.equalTo(@(self.iconTextModel.topBottomMargin));
        make.bottom.equalTo(@(-self.iconTextModel.topBottomMargin));
        make.height.equalTo(@(self.iconTextModel.iconW / self.iconTextModel.whProportion));
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(0);
    }];

    // title
    _newsCallLabel = [UILabel new];
    _newsCallLabel.text = self.iconTextModel.labelText;
    _newsCallLabel.font = self.iconTextModel.font;
    [contentView addSubview:_newsCallLabel];
    [_newsCallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.iconTextModel.topBottomMargin);
        make.bottom.equalTo(self).offset(-self.iconTextModel.topBottomMargin);
        make.left.equalTo(@0);
        make.right.equalTo(self->_newsImgView.mas_left).offset(-self.iconTextModel.spaceWidth);
    }];
}


@end
