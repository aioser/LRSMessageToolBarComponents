//
//  LRSMessageToolBarConfigure.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/16.
//

import UIKit

@objc public class LRSMessageToolBarConfigure: NSObject {

    struct RecordButton {
        var state: ButtonState
        var clickTime: TimeInterval
        var height: CGFloat = 36
        var top: CGFloat = 6
    }

    struct InputTextView {
        var leftMargin: CGFloat
        var topMargin: CGFloat
        var acceptLength: Int
        var placeholder: String
        var placeHolderColor: UIColor
        var maxHeight: CGFloat
        var minHeight: CGFloat
    }

    struct ModeSwitchButton {
        var leftMargin: CGFloat
        var buttonSize: CGSize
        var state: ButtonState
    }

    struct ActionButton {
        var rightButtonsMargin: CGFloat
        var rightButtonsXSpacing: CGFloat
        var buttonSize: CGSize
        var emojiButtonState: ButtonState
        var imagePickerButtonState: ButtonState
    }

    class ButtonState: NSObject {
        lazy var imageSource: [UIControl.State: UIImage] = [:]
        lazy var titleSource: [UIControl.State: NSAttributedString] = [:]

        func image(_ image: UIImage?, for state: UIControl.State) {
            imageSource[state] = image
        }

        func image(for state: UIControl.State) -> UIImage? {
            return imageSource[state]
        }

        func title(_ title: NSAttributedString, for state: UIControl.State) {
            titleSource[state] = title
        }

        func title(for state: UIControl.State) -> NSAttributedString? {
            return titleSource[state]
        }
    }

    lazy var recordButton: RecordButton = RecordButton(state: ButtonState().then {
        var recordImage = UIImage.image(named: "bt_im_voice")
        $0.image(recordImage, for: .normal)
        var recordImage_p = UIImage.image(named: "bt_im_voice_p")
        $0.image(recordImage_p, for: .selected)

        let titleAttribute = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: UIColor.black
        ]
        $0.title(NSAttributedString(string: "按住 说话", attributes: titleAttribute), for: .normal)
        $0.title(NSAttributedString(string: "松开 结束", attributes: titleAttribute), for: .selected)
    }, clickTime: 0)

    lazy var textView: InputTextView = InputTextView(leftMargin: 15, topMargin: 14, acceptLength: 200, placeholder: "输入聊天内容...", placeHolderColor: UIColor.color(named: "Color_16_13_25") ?? .lightGray, maxHeight: 88, minHeight: 20)

    lazy var buttons: ActionButton = ActionButton(rightButtonsMargin: 13, rightButtonsXSpacing: 13, buttonSize: CGSize(width: 24, height: 24), emojiButtonState: ButtonState().then{
        $0.image(.image(named: "information_expression_normal"), for: .normal)
        $0.image(.image(named: "information_expression_selected"), for: .selected)
    }, imagePickerButtonState: ButtonState().then{
        $0.image(.image(named: "im_pic"), for: .normal)
        $0.image(.image(named: "im_pic_selected"), for: .selected)
    })
    
    lazy var modeSwitch: ModeSwitchButton = ModeSwitchButton(leftMargin: 12, buttonSize: CGSize(width: 28, height: 28), state: ButtonState().then{
        $0.image(.image(named: "information_keyboard_normal"), for: .selected)
        $0.image(.image(named: "im_voice_selected"), for: .normal)
    })

    public static let `default` = LRSMessageToolBarConfigure()
}

extension UIControl.State: Hashable {
    public var hashValue: Int {
        return "LRSMessageToolBarConfigure_Control_State_\(self.rawValue)".hashValue
    }
}
