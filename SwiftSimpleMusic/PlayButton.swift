//
//  PlayButton.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

class PlayButton: UIButton {

    var isPlaying: Bool = false {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ bounds: CGRect) {
        // Always draw in a centered square so the button stays round even if its frame isn't.
        let side = min(bounds.width, bounds.height)
        let rect = CGRect(x: bounds.midX - side / 2, y: bounds.midY - side / 2, width: side, height: side)

        // Shadow circle
        let circleRect2 = CGRect(x: rect.minX + rect.size.width*0.1 + 1, y: rect.minY + rect.size.height*0.1 + 1, width: rect.size.width*0.8, height: rect.size.height*0.8)
        let circle2 = UIBezierPath(ovalIn: circleRect2)
        circle2.lineWidth = 5
        UIColor.black.withAlphaComponent(0.1).setStroke()
        circle2.stroke()

        // Main circle
        let circleRect = CGRect(x: rect.minX + rect.size.width*0.1, y: rect.minY + rect.size.height*0.1, width: rect.size.width*0.8, height: rect.size.height*0.8)
        let circle = UIBezierPath(ovalIn: circleRect)
        tintColor.setStroke()
        UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1).setFill()
        circle.lineWidth = 1
        circle.fill()
        circle.stroke()

        tintColor.setFill()

        if isPlaying {
            // Pause icon: two vertical bars centered in circle
            let barWidth = rect.size.width * 0.12
            let barHeight = rect.size.height * 0.38
            let gap = rect.size.width * 0.10
            let totalWidth = barWidth * 2 + gap
            let startX = rect.midX - totalWidth / 2
            let startY = rect.midY - barHeight / 2

            UIBezierPath(rect: CGRect(x: startX, y: startY, width: barWidth, height: barHeight)).fill()
            UIBezierPath(rect: CGRect(x: startX + barWidth + gap, y: startY, width: barWidth, height: barHeight)).fill()
        } else {
            // Play icon: right-pointing triangle; offset slightly right for visual balance
            let triWidth = rect.size.width * 0.32
            let triHeight = rect.size.height * 0.38
            let startX = rect.midX - triWidth * 0.4
            let startY = rect.midY - triHeight / 2

            let path = UIBezierPath()
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: startX, y: startY + triHeight))
            path.addLine(to: CGPoint(x: startX + triWidth, y: rect.midY))
            path.close()
            path.fill()
        }
    }
}
