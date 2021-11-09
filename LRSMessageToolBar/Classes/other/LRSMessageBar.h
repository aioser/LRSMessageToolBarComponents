
#import <UIKit/UIKit.h>
#import "LRSMessageToolBarConfigure.h"
#import "LRSMessageToolBarDefines.h"

@interface LRSMessageBar : UIView

- (instancetype)initWithConfigure:(LRSMessageToolBarConfigure *)configure;

@property (nonatomic, weak) id<LRSMessageToolBarDelegate> delegate;
@property (nonatomic, weak) id<LRSAudioPermissionDatasource> datasource;

- (CGFloat)coolkeyboardHeight;

- (void)endRecording;

@end
