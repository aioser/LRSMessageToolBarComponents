

#import "LRSMessageToolBarRecordButton.h"

@interface LRSMessageToolBarRecordButton ()

@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (nonatomic, assign, readwrite) BOOL inArea; //  在区域内

@end

@implementation LRSMessageToolBarRecordButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self.timer invalidate];
    __weak typeof(self) weakSelf = self;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.clickTime repeats:false block:^(NSTimer * _Nonnull timer) {
        NSLog(@"Touch Began");
        if (weakSelf.touchBegan) {
            weakSelf.touchBegan(weakSelf);
        }
        weakSelf.selected = true;
        [timer invalidate];
        weakSelf.timer = nil;
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.inArea = YES;
    self.timer = timer;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.timer) {
        return;
    }
    UITouch *anchTouch = [touches anyObject];
    CGPoint point = [anchTouch locationInView:self];
    BOOL isInArea = (point.y >= 0 && point.y <= self.areaY);
    if (self.inArea != isInArea) {
        if (self.inArea) {
            if (self.dragOutside) {
                NSLog(@"Drag Outside");
                self.dragOutside(self);
            }
        } else {
            if (self.dragEnter) {
                NSLog(@"Drag Enter");
                self.dragEnter(self);
            }
        }
        self.inArea = isInArea;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    if (self.inArea) {
        NSLog(@"Touch End");
        if (self.touchEnd) {
            self.touchEnd(self);
        }
    } else {
        NSLog(@"Drag Outside Release");
        if (self.dragOutsideRelease) {
            self.dragOutsideRelease(self);
        }
    }
    self.selected = false;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    NSLog(@"Touch Cancell");
    if (self.touchEnd) {
        self.touchEnd(self);
    }
    self.selected = false;
}

- (void)dealloc {
    
}

@end
