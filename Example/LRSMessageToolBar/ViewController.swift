//
//  ViewController.swift
//  LRSMessageToolBar
//
//  Created by 刘sama on 10/27/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

import UIKit
import LRSMessageToolBarComponents
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let inputView = LRSMessageBar(frame: CGRect(x: 0, y: LRSMessageToolBarHelper.screenHeight() - 33, width: LRSMessageToolBarHelper.screenWidth(), height: 33), configure: .default())
        view.addSubview(inputView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

