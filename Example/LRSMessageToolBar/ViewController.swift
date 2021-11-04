//
//  ViewController.swift
//  LRSMessageToolBar
//
//  Created by 刘sama on 10/27/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

