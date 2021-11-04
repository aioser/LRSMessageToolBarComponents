//
//  LRSMessageToolBarDefines.h
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/10/27.
//

#ifndef LRSMessageToolBarDefines_h
#define LRSMessageToolBarDefines_h

@class LRSMessageBar;

@protocol LRSMessageToolBarTextInputDelegate <NSObject>

@optional
- (void)messageToolBarInputTextViewDidBeginEditing:(LRSMessageBar *)bar;

- (void)messageToolBarInputTextViewWillBeginEditing:(LRSMessageBar *)bar;

- (void)messageToolBarInputTextViewDidEndEditing:(LRSMessageBar *)bar;

- (void)messageToolBarDidClickedReturn:(LRSMessageBar *)bar;

@end

@protocol LRSMessageToolBarButtonsActionsDelegate <NSObject>

@optional
- (void)messageToolBar:(LRSMessageBar *)bar buttonDidClicked:(NSInteger)buttonId;

- (BOOL)messageToolBarBeganToSpeak:(LRSMessageBar *)bar;

- (void)messageToolBarEndSpeaking:(LRSMessageBar *)bar;

- (void)messageToolBarSlideTopToCancelRecording:(LRSMessageBar *)bar;

- (void)messageToolBarDragEnterRecordScope:(LRSMessageBar *)bar;

- (void)messageToolBarDragOutRecordScope:(LRSMessageBar *)bar;
@end

@protocol LRSMessageToolBarPositionDelegate <NSObject>

@optional
- (void)messageToolBar:(LRSMessageBar *)bar fromRect:(CGRect)from to:(CGRect)toRect;
@end

@protocol LRSMessageToolBarDelegate <LRSMessageToolBarTextInputDelegate, LRSMessageToolBarButtonsActionsDelegate, LRSMessageToolBarPositionDelegate>

@end

#endif /* LRSMessageToolBarDefines_h */
