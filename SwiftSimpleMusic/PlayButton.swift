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
        let width: CGFloat = rect.size.width/2;
        let height = rect.size.height/2;
        let x = rect.size.width/2 - width/2;
        let y = rect.size.height/2 - height/2;
        let small = CGRect(x: x, y: y, width: width, height: height);
        
        //shadow
        let circleRect2 = CGRect(x: rect.size.width*0.1 + 1, y: rect.size.height*0.1 + 1, width: rect.size.width*0.8, height: rect.size.height*0.8)
        //circle
        let circle2: UIBezierPath = UIBezierPath.init(ovalIn: circleRect2)
        circle2.lineWidth = 5
        let blackAlpha = UIColor.black.withAlphaComponent(0.1)
        blackAlpha.setStroke()
        circle2.stroke()
        
        let circleRect = CGRect(x: rect.size.width*0.1, y: rect.size.height*0.1, width: rect.size.width*0.8, height: rect.size.height*0.8)
        //circle
        let circle: UIBezierPath = UIBezierPath.init(ovalIn: circleRect)
        tintColor.setStroke()
        UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1).setFill()
        circle.lineWidth = 1
        circle.fill()
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
