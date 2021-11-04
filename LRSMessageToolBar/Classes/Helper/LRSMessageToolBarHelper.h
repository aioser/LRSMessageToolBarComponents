//
//  LRSMessageToolBarHelper.h
//  LRSMessageToolBar-LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#import <Foundation/Foundation.h>
#import "LRSMemePackageConfigure.h"

NS_ASSUME_NONNULL_BEGIN

#define LRSMessageToolBarUISize_(value) (value * LRSMessageToolBarHelper.scale)

@interface LRSMessageToolBarHelper : NSObject
@property (nonatomic, class) CGFloat scale;
@property (nonatomic, class, getter=isIPhoneXSeriesDevice) BOOL iPhoneXSeriesDevice;
+ (NSBundle *)bundle;
+ (UIImage *)imageNamed:(NSString *)named;
+ (UIColor *)colorNamed:(NSString *)named;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (NSArray<LRSMemePackageConfigure *> *)allEmojis;
+ (CGSize)sizeForEmojiKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
