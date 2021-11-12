
#import <UIKit/UIKit.h>
#import "LRSMemePackageViewDefines.h"

@class LRSMemePackageConfigureItem;
@class LRSMemePackageConfigure;
@class LRSMemePackagesView;
NS_ASSUME_NONNULL_BEGIN
@interface LRSMemePackagesView : UIView <NSObject>
- (instancetype)initWithFrame:(CGRect)frame configures:(NSArray<LRSMemePackageConfigure *> *)configures;

+ (CGFloat)boardHeight;

@property (nonatomic, copy) LRSMemePackageItemsHandler itemHandler;

@property (nonatomic, copy) LRSMemePackageBackspaceHandler backspaceHandler;

@property (nonatomic, copy) LRSMemePackageSendOutHandler confirmHandler;

- (void)buildUI;
@end
NS_ASSUME_NONNULL_END
