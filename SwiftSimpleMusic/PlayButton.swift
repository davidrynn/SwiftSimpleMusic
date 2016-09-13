//
//  PlayButton.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

class PlayButton: UIButton {
    override func drawRect(rect: CGRect) {
        let width: CGFloat = rect.size.width/4;
        let height = rect.size.height/4;
        let x = rect.size.width/2 - width/2;
        let y = rect.size.height/2 - height/2;
        let small = CGRectMake(x, y, width, height);
        
        let circleRect = CGRectMake(rect.size.width*0.05, rect.size.height*0.05, rect.size.width*0.9, rect.size.height*0.9);
        //circle
        let circle: UIBezierPath = UIBezierPath.init(ovalInRect: circleRect)
        tintColor.setStroke()
        circle.lineWidth = 1
        circle.stroke()

        //// Bezier Drawing
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(CGRectGetMinX(small) + small.size.width/4, CGRectGetMinY(small)))
        bezierPath.addLineToPoint(CGPointMake(CGRectGetMinX(small) + small.size.width/4, CGRectGetMaxY(small)))
        bezierPath.addLineToPoint(CGPointMake(CGRectGetMaxX(small), CGRectGetMidY(rect)))
        bezierPath.closePath()
        tintColor.setFill()
        bezierPath.lineWidth = 1
        bezierPath.fill()
    }

    
}
