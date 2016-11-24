//
//  BackButton.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

class BackButton: UIButton {
    
    
    override func draw(_ rect: CGRect) {
        let width: CGFloat = rect.size.width/4;
        let height = rect.size.height/4;
        let x = rect.size.width/2 - width/2;
        let y = rect.size.height/2 - height/2;
        let small = CGRect(x: x, y: y, width: width, height: height);
        
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: small.midX, y: small.minY))
        bezierPath.addLine(to: CGPoint(x: small.midX, y: small.maxY))
        bezierPath.addLine(to: CGPoint(x: small.minX, y: rect.midY))
        bezierPath.close()
        tintColor.setFill()
        bezierPath.lineWidth = 1
        bezierPath.fill()
        
        let bezierPath2 = UIBezierPath()
        bezierPath2.move(to: CGPoint(x: small.maxX, y: small.minY))
        bezierPath2.addLine(to: CGPoint(x: small.maxX, y: small.maxY))
        bezierPath2.addLine(to: CGPoint(x: small.midX, y: rect.midY))
        bezierPath2.close()
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
