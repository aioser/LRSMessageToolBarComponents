

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface LRSMessageToolBarRecordButton : UIButton

@property (nonatomic, copy) void(^touchBegan)(LRSMessageToolBarRecordButton *button);
@property (nonatomic, copy) void(^dragOutside)(LRSMessageToolBarRecordButton *button);
@property (nonatomic, copy) void(^dragEnter)(LRSMessageToolBarRecordButton *button);
@property (nonatomic, copy) void(^touchEnd)(LRSMessageToolBarRecordButton *button);
@property (nonatomic, copy) void(^dragOutsideRelease)(LRSMessageToolBarRecordButton *button);

@property (nonatomic, assign) CGFloat clickTime; //  设置长按时间
@property (nonatomic, strong, readonly) NSTimer *timer;
@property (nonatomic, assign, readonly) BOOL inArea; //  在区域内
@property (nonatomic, assign) int areaY;             //  设置识别高度

@end
NS_ASSUME_NONNULL_END
