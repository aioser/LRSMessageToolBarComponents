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
    let bar = LRSMessageBar(frame: CGRect(x: 0, y: LRSMessageToolBarHelper.screenHeight() - 33, width: LRSMessageToolBarHelper.screenWidth(), height: 33), configure: .default())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bar)
        bar.becomeFirstResponder()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc func tap() {
        bar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

