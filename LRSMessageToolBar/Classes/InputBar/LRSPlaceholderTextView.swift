 //
//  LRSPlaceholderTextView.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/16.
//

import UIKit
import Then

public class LRSPlaceholderTextView: UITextView {

    var placeHolder: String? {
        set {
            placeHolderLabel.text = newValue
        }
        get {
            return placeHolderLabel.text
        }
    }
    var placeHolderColor: UIColor? {
        set {
            placeHolderLabel.textColor = newValue
        }
        get {
            return placeHolderLabel.textColor
        }
    }
    lazy var placeHolderLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.width, height: 20)).then{
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 16)
    }

    public override var font: UIFont? {
        willSet {
            placeHolderLabel.font = newValue
        }
    }

    public override var text: String! {
        willSet {
            guard let value = newValue else {
                return
            }
            placeHolderLabel.isHidden = value.count > 0
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeHolderLabel)
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: .main) {[weak self] noti in
            if let textCount = self?.text.count, let placeHodlerCount = self?.placeHolder?.count {
                self?.placeHolderLabel.isHidden = !(textCount == 0 && placeHodlerCount != 0)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
