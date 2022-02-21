//
//  LRSMessageToolBarPageControl.swift
//  LRSMessageToolBarComponents
//
//  Created by sama 刘 on 2021/11/17.
//

import UIKit

class LRSMessageToolBarPageControl: UIControl {

    let numberOfPages: Int

    var currentPage: Int = 0 {
        didSet {
            if defersCurrentPageDisplay {
                setNeedsDisplay()
            }
        }
    }

    var defersCurrentPageDisplay = true
    var onColor: UIColor = .white
    var offColor: UIColor = .init(white: 0.7, alpha: 0.5)
    var indicatorDiameter = 4.0
    var indicatorSpace = 12.0


    init(numberOfPages: Int) {
        self.numberOfPages = numberOfPages
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.setAllowsAntialiasing(true)
        let bounce = self.bounds
        let dotWidth = Double(numberOfPages) * indicatorDiameter + Double(max(0, numberOfPages - 1)) * indicatorSpace
        var x = bounce.midX - dotWidth / 2
        let y = bounce.midY - indicatorDiameter / 2
        for index in 0 ..< numberOfPages {
            let dotRect = CGRect(x: x, y: y, width: indicatorDiameter, height: indicatorDiameter)
            if index == currentPage {
                context?.setFillColor(onColor.cgColor)
            } else {
                context?.setFillColor(offColor.cgColor)
            }
            context?.fillEllipse(in: dotRect.insetBy(dx: -0.5, dy: -0.5))
            x += indicatorSpace + indicatorDiameter
        }
    }

    func size() -> CGSize {
        return CGSize(width: CGFloat(numberOfPages) * indicatorDiameter + CGFloat(numberOfPages - 1) * indicatorSpace + 5, height: max(20, indicatorDiameter + 4))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self) else {
            return
        }
        if location.x < self.bounds.width / 2 {
            currentPage = max(currentPage - 1, 0)
        } else {
            currentPage = min(currentPage + 1, numberOfPages - 1)
        }
        sendActions(for: .valueChanged)
    }

}
