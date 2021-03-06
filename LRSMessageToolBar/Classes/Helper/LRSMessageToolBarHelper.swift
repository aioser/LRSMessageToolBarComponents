//
//  LRSMessageToolBarHelper.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/16.
//

import UIKit
import Then

@objc
public class LRSMessageToolBarHelper: NSObject {
    @objc public static var safeAreaHeight: CGFloat = 33

    @objc static func emojis() -> LRSMemePackageConfigure? {
        var plistName: String
        if #available(iOS 12.1, *) {
            plistName = "EmojisList_ios>12.1"
        } else if #available(iOS 11.1, *) {
            plistName = "EmojisList_ios>=11"
        } else {
            plistName = "EmojisList_ios<11";
        }
        guard let path = Bundle.now?.path(forResource: plistName, ofType: "plist") else {
            return nil
        }
        guard let values = NSArray(contentsOfFile: path) as? [String] else {
            return nil
        }
        let emojis = values.map { value in
            return LRSMemePackageConfigure.Item(emojiValue: value)
        }
        let configure = LRSMemePackageConfigure(emojis: emojis, columnCount: 8)
        return configure
    }

    static func sizeOfEmoji(key: String) -> CGSize {
        return CGSize(width: 45, height: 37)
    }

}


internal extension UIScreen {
    var width: CGFloat {
        return self.bounds.size.width
    }

    var height: CGFloat {
        return self.bounds.size.height
    }
}

internal extension Bundle {
    static var now: Bundle? {
        let bundle = Bundle(for: LRSMessageToolBarHelper.self)
        guard let url = bundle.url(forResource: "LRSMessageToolBar", withExtension: "bundle") else {
            return .main
        }
        return Bundle(url: url)
    }
}


internal extension UIImage {
    static func image(named: String) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(named: named, in: .now, with: nil)
        } else {
            return UIImage(named: named, in: .now, compatibleWith: nil)
        }
    }

    static func image(from color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
}


internal extension UIColor {
    static func color(named: String) -> UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(named: named, in: .now, compatibleWith: nil)
        } else {
            return nil
            // Fallback on earlier versions
        }
    }
}



