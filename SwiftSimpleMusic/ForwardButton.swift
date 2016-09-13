//
//  ForwardButton.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

class ForwardButton: UIButton {

    override func drawRect(rect: CGRect) {
        let width: CGFloat = rect.size.width/4;
        let height = rect.size.height/4;
        let x = rect.size.width/2 - width/2;
        let y = rect.size.height/2 - height/2;
        let small = CGRectMake(x, y, width, height);
        
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(CGRectGetMinX(small), CGRectGetMinY(small)))
        bezierPath.addLineToPoint(CGPointMake(CGRectGetMinX(small), CGRectGetMaxY(small)))
        bezierPath.addLineToPoint(CGPointMake(CGRectGetMidX(small), CGRectGetMidY(small)))
        bezierPath.closePath()
        tintColor.setFill()
        bezierPath.lineWidth = 1
        bezierPath.fill()
 
        let bezierPath2 = UIBezierPath()
        bezierPath2.moveToPoint(CGPointMake(CGRectGetMidX(small), CGRectGetMinY(small)))
        bezierPath2.addLineToPoint(CGPointMake(CGRectGetMidX(small), CGRectGetMaxY(small)))
        bezierPath2.addLineToPoint(CGPointMake(CGRectGetMaxX(small), CGRectGetMidY(small)))
        bezierPath2.closePath()
        tintColor.setFill()
        bezierPath2.lineWidth = 1
        bezierPath2.fill()

    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
