//
//  ViewController.swift
//  LRSMessageToolBar
//
//  Created by 刘sama on 10/27/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

import UIKit
import SnapKit
import LRSMessageToolBarComponents

class ViewController: UIViewController {
    let bar = LRSMessageBar(frame: CGRect(x: 0, y: 400, width: UIScreen.main.bounds.size.width, height: 33), configure: .default)
    override func viewDidLoad() {
        super.viewDidLoad()
        bar.becomeFirstResponder()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tap)
        view.addSubview(bar)
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

