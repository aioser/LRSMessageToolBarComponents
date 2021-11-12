//
//  LRSMesssageBarProtocol.swift
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/11/9.
//

import Foundation

@objc public protocol LRSMessageToolBarTextInputDelegate: NSObjectProtocol {

    @objc optional
    func messageToolBarInputTextViewDidBeginEditing(bar: LRSMessageBar)

    func messageToolBarInputTextViewWillBeginEditing(bar: LRSMessageBar)

    func messageToolBarInputTextViewDidEndEditing(bar: LRSMessageBar)

    func messageToolBarDidClickedReturn(bar: LRSMessageBar, text: String)
    
    func messageToolBarShouldBeginEditting(bar: LRSMessageBar) -> Bool
}

@objc public protocol LRSMessageToolBarButtonsActionsDelegate: NSObjectProtocol {

    @objc optional
    func messageToolBarButtonDidClicked(bar: LRSMessageBar, text: String)

    func messageToolBarBeganToSpeak(bar: LRSMessageBar)

    func messageToolBarEndSpeaking(bar: LRSMessageBar)

    func messageToolBarSlideTopToCancelRecording(bar: LRSMessageBar)

    func messageToolBarDragEnterRecordScope(bar: LRSMessageBar)
    
    func messageToolBarDragOutRecordScope(bar: LRSMessageBar)
}

@objc public protocol LRSMessageToolBarPositionDelegate: NSObjectProtocol {

}

@objc public protocol LRSMessageToolBarAudioPermissionDelegate: NSObjectProtocol {
    @objc optional
    func audioPermission() -> Bool
}

public typealias LRSMesssageBarProtocol = LRSMessageToolBarPositionDelegate&LRSMessageToolBarButtonsActionsDelegate&LRSMessageToolBarTextInputDelegate&LRSMessageToolBarAudioPermissionDelegate
