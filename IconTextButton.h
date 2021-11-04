//
//  IconTextButton.h
//  WarnChat
//
//  Created by Apple on 16/4/25.
//  Copyright © 2016年 langrengame.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ICON_LOCAL_TYPE) {
    ICON_FRONT_TYPE,
    ICON_LAST_TYPE
};

@interface IconTextModel : NSObject

@property (nonatomic, assign) ICON_LOCAL_TYPE type;    // icon前后类型
@property (nonatomic, copy) UIImage *iconImg;          // icon
@property (nonatomic, assign) CGFloat spaceWidth;      // icon和title间距
@property (nonatomic, copy) NSString *labelText;       // title
@property (nonatomic, assign) CGFloat topBottomMargin; // 图标距离上下间距
@property (nonatomic, assign) CGFloat iconW;           // icon高
@property (nonatomic, assign) CGFloat whProportion;    // icon宽高比
@property (nonatomic, strong) UIFont *font;            // 图标宽高

@end

@interface IconTextButton : UIButton

@property (nonatomic, strong) UIImageView *newsImgView;
@property (nonatomic, strong) UILabel *newsCallLabel;
@property (nonatomic, strong) IconTextModel *iconTextModel;

@end
