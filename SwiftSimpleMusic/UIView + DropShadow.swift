//
//  UIView + DropShadow.swift
//  Notify-NYC-iOS
//
//  Created by David Rynn on 2/23/17.
//  Copyright © 2017 Rynn, David. All rights reserved.
//
// credit to ChiefAashish http://stackoverflow.com/questions/39624675/add-shadow-on-uiview-using-swift-3

import UIKit

extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 8
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
}
