//
//  DXMessageToolBarTextHandler.swift
//  LangRen
//
//  Created by 刘俊臣 on 2020/4/10.
//  Copyright © 2020 langrengame.com. All rights reserved.
//

import UIKit

@objc class DXMessageToolBarTextHandler: NSObject {
    @objc static func handleText(text: String, maxLength: Int) -> String {
        return String(text.prefix(maxLength))
    }
    @objc static func textCount(text: String) -> Int {
        return text.count
    }
    @objc static func deleteLastWord(now: String) -> String {
        if now.count == 0 {
            return now
        }
        return String(now.prefix(now.count - 1))
    }
}
