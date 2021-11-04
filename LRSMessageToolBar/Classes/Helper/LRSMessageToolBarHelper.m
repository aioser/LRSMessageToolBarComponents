//
//  LRSMessageToolBarHelper.m
//  LRSMessageToolBar-LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#import "LRSMessageToolBarHelper.h"

@implementation LRSMessageToolBarHelper

static CGFloat kLRSMessageToolBarHelperScale = 1;
static bool kLRSIPhoneXSeriesDevice = true;

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)scale {
    return kLRSMessageToolBarHelperScale;
}

+ (void)setScale:(CGFloat)scale {
    kLRSMessageToolBarHelperScale = scale;
}

+ (NSBundle *)bundle {
    static NSBundle *sourceBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[LRSMessageToolBarHelper class]];
        NSURL *url = [bundle URLForResource:@"LRSMessageToolBar" withExtension:@"bundle"];
        sourceBundle = [NSBundle bundleWithURL:url];
    });
    return sourceBundle;
}

+ (UIImage *)imageNamed:(NSString *)named {
    return [UIImage imageNamed:named inBundle:[self bundle] compatibleWithTraitCollection:nil];
}

+ (UIColor *)colorNamed:(NSString *)named {
    return [UIColor colorNamed:named inBundle:[self bundle] compatibleWithTraitCollection:nil];
}

+ (NSArray<LRSMemePackageConfigure *> *)allEmojis {
    NSString *plistName = nil;
    if (@available(iOS 12.1, *)) {
        plistName = @"EmojisList_ios>12.1";
    } else if (@available(iOS 11.1, *)) {
        plistName = @"EmojisList_ios>=11";
    } else {
        plistName = @"EmojisList_ios<11";
    }
    NSString *plistPath = [[self bundle] pathForResource:plistName ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *emojis = [NSMutableArray arrayWithCapacity:arr.count];
    for (int i = 0; i < arr.count; i++) {
        LRSMemePackageConfigureItem *emoji = [[LRSMemePackageConfigureItem alloc] init];
        emoji.emojiValue = [arr objectAtIndex:i];
        [emojis addObject:emoji];
    }
    LRSMemePackageConfigure *configure = [[LRSMemePackageConfigure alloc] init];
    configure.emojis = emojis;
    configure.key = @"default";
    configure.coverImageName = @"information_expression_normal";
    configure.row = 4;
    configure.column = 9;
    return @[configure];
}

+ (CGSize)sizeForEmojiKey:(NSString *)key {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = CGSizeMake(45, 37);
    });
    return size;
}

+ (void)setIPhoneXSeriesDevice:(BOOL)iPhoneXSeriesDevice {
    kLRSIPhoneXSeriesDevice = iPhoneXSeriesDevice;
}

+ (BOOL)isIPhoneXSeriesDevice {
    return kLRSIPhoneXSeriesDevice;
}
@end
