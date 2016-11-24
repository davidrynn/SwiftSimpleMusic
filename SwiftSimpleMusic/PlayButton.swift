//
//  PlayButton.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

class PlayButton: UIButton {
    override func draw(_ rect: CGRect) {
        let width: CGFloat = rect.size.width/4;
        let height = rect.size.height/4;
        let x = rect.size.width/2 - width/2;
        let y = rect.size.height/2 - height/2;
        let small = CGRect(x: x, y: y, width: width, height: height);
        
        let circleRect = CGRect(x: rect.size.width*0.05, y: rect.size.height*0.05, width: rect.size.width*0.9, height: rect.size.height*0.9);
        //circle
        let circle: UIBezierPath = UIBezierPath.init(ovalIn: circleRect)
        tintColor.setStroke()
        circle.lineWidth = 1
        circle.stroke()

        //// Bezier Drawing
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: small.minX + small.size.width/4, y: small.minY))
        bezierPath.addLine(to: CGPoint(x: small.minX + small.size.width/4, y: small.maxY))
        bezierPath.addLine(to: CGPoint(x: small.maxX, y: rect.midY))
        bezierPath.close()
        tintColor.setFill()
        bezierPath.lineWidth = 1
        bezierPath.fill()
    }

    
}
