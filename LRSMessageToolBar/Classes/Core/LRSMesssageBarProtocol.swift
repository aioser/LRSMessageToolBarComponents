//
//  LRSMesssageBarProtocol.swift
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/11/9.
//

import Foundation

@objc public protocol LRSMessageToolBarTextInputDelegate: NSObjectProtocol {

    @objc optional func messageToolBarInputTextViewDidBeginEditing(bar: LRSMessageBar)

    @objc optional func messageToolBarInputTextViewWillBeginEditing(bar: LRSMessageBar)

    @objc optional func messageToolBarInputTextViewDidEndEditing(bar: LRSMessageBar)

    @objc optional func messageToolBarDidClickedReturn(bar: LRSMessageBar, text: String)
    
    @objc optional func messageToolBarShouldBeginEditting(bar: LRSMessageBar) -> Bool
}

@objc public protocol LRSMessageToolBarButtonsActionsDelegate: NSObjectProtocol {
    
    @objc optional func messageToolBarBeganToSpeak(bar: LRSMessageBar)

    @objc optional func messageToolBarEndSpeaking(bar: LRSMessageBar)

    @objc optional func messageToolBarSlideTopToCancelRecording(bar: LRSMessageBar)

    @objc optional func messageToolBarDragEnterRecordScope(bar: LRSMessageBar)
    
    @objc optional func messageToolBarDragOutRecordScope(bar: LRSMessageBar)
}

@objc public protocol LRSMessageBarDelegate: NSObjectProtocol {
    @objc func sendOut(bar: LRSMessageBar, text: String)
}

@objc public protocol LRSMessageToolBarAudioPermissionDelegate: NSObjectProtocol {
    @objc optional
    func audioPermission() -> Bool
}

public typealias LRSMesssageBarProtocol = LRSMessageBarDelegate&LRSMessageToolBarButtonsActionsDelegate&LRSMessageToolBarTextInputDelegate&LRSMessageToolBarAudioPermissionDelegate
