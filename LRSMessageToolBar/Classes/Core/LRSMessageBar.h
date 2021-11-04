
#import <UIKit/UIKit.h>
#import "LRSMessageToolBarConfigure.h"
#import "LRSMessageToolBarDefines.h"

@interface LRSMessageBar : UIView

- (instancetype)initWithConfigure:(LRSMessageToolBarConfigure *)configure;

@property (nonatomic, weak) id<LRSMessageToolBarDelegate> delegate;

- (CGFloat)coolkeyboardHeight;

- (void)endRecording;

@end
