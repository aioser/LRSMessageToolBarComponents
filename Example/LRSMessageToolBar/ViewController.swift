//
//  ViewController.swift
//  LRSMessageToolBar
//
//  Created by 刘sama on 10/27/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

import UIKit
import LRSMessageToolBar
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let emojiButton = UIButton(type: .system)
        emojiButton.setTitle("emoji", for: .normal)
        view.addSubview(emojiButton)
        emojiButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 50))
        }
        emojiButton.addTarget(self, action: #selector(emojiAction), for: .touchUpInside)

        let inputButton = UIButton(type: .system)
        inputButton.setTitle("inputView", for: .normal)
        view.addSubview(inputButton)
        inputButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.size.equalTo(CGSize(width: 200, height: 50))
            make.centerX.equalToSuperview()
        }
        inputButton.addTarget(self, action: #selector(inputAction), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }


    @objc func emojiAction() {
        let emojis = LRSMessageToolBarHelper.allEmojis()
        let contentView = LRSMemePackgaesView(frame: CGRect(x: 0, y: LRSMessageToolBarHelper.screenHeight() - LRSMemePackgaesView.boardHeight(), width: LRSMessageToolBarHelper.screenWidth(), height: LRSMemePackgaesView.boardHeight()), configures: emojis)
        contentView.backspaceHandler = { _ in
            print("backspaceHandler")
        }
        contentView.itemHandler = { view, item in
            print("itemHandler")
        }
        contentView.buildUI()
        view.addSubview(contentView)
    }

    @objc func inputAction() {
        let inputView = LRSMessageToolsBar.toolBar(with: LRSMessageToolBarConfigure())
        inputView.frame = CGRect(x: 0, y: LRSMessageToolBarHelper.screenHeight() - 200, width: LRSMessageToolBarHelper.screenWidth(), height: 200)
        view.addSubview(inputView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

