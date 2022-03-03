//
//  LRSMemePackageConfigure.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/16.
//

import UIKit

class LRSMemePackageConfigure: NSObject {

    struct Item {
        let emojiValue: String
    }
    
    var emojis: [Item]
    var columnCount: Int

    init(emojis:[Item], columnCount: Int) {
        self.emojis = emojis
        self.columnCount = columnCount
    }
}
