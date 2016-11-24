//
//  UIView+Layout.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 10/26/15.
//  Copyright © 2015 NYC DoITT. All rights reserved.
//

import UIKit

extension UIView {
    
    /** Center horizontally in the superview. */
    func centerHorizontallyInSuperview() {
        guard let superview = self.superview else {
            return
        }
        self.x = (superview.width - self.width) / 2
    }
    
    /** Center vertically in the superview. */
    func centerVerticallyInSuperview() {
        guard let superview = self.superview else {
            return
        }
        self.y = (superview.height - self.height) / 2
    }
    
    /** Convenience property for the size of this UIView. */
    var size: CGSize {
        get { return self.frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    /** Convenience property for the height of this UIView. */
    var height: CGFloat {
        get { return self.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /** Convenience property for the width of this UIView. */
    var width: CGFloat {
        get { return self.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /** Convenience property for the origin of this UIView. */
    var origin: CGPoint {
        get { return self.frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    /** Convenience property for the X of this UIView. */
    var x: CGFloat {
        get { return self.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /** Convenience property for the Y of this UIView. */
    var y: CGFloat {
        get { return self.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /** Convenience property for the MaxX of this UIView. */
    var maxX: CGFloat {
        get { return self.origin.x + self.size.width }
    }
    
    /** Convenience property for the MaxY of this UIView. */
    var maxY: CGFloat {
        get { return self.origin.y + self.size.height }
    }
    
    /** Pass in an array of subviews, and the group will be placed in the vertical center of this view. */
    func centerSubviewsVertically(_ subviews: [UIView]) {
        if subviews.count == 0 { return }
        
        let minY: CGFloat = subviews.map{$0.y}.min()!
        let maxY: CGFloat = subviews.map{$0.maxY}.max()!
        let groupHeight = maxY - minY
        
        let topMargin = (self.height - groupHeight) / 2
        let delta = minY - topMargin
        
        for view in subviews {
            view.y -= delta
        }
    }
    
}
