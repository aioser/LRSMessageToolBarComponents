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
    var coverImageName: String
    var row: Int
    var column: Int
    let key: String

    init(key: String, emojis:[Item], coverImageName: String, row: Int, column: Int) {
        self.key = key
        self.emojis = emojis
        self.coverImageName = coverImageName
        self.row = row
        self.column = column
    }
}
