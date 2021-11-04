//
//  LRSMessageToolBarConfigure.m
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#import "LRSMessageToolBarConfigure.h"

@implementation LRSMessageToolBarConfigure

- (void)defaultConfigure {
    self.recordingBtnColorSelected = [UIImage imageNamed:@"bt_im_voice_p"];
    self.recordingBtnColorNormal = [UIImage imageNamed:@"bt_im_voice"];
    [self.faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_expression_normal", imageNamePrefix]] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_expression_selected", imageNamePrefix]] forState:UIControlStateHighlighted];
}
@end
