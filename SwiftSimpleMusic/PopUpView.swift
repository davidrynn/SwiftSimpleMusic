//
//  PopUpView.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 4/20/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

class PopUpView: UIView {

    
    //topbar will possibly have fade in/out
    //image
    //button for up/down
    @IBOutlet weak var topBar: PopUpTopBarView!

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet fileprivate weak var label: UILabel!
    var labelText: String {
        get {
            return label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }
    
    
    var lastLocation: CGPoint = CGPoint(x: 0,y: 0)
    
    var blurView: UIVisualEffectView = UIVisualEffectView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.transparencySetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.transparencySetup()
        
    }
    
    
    class func instanceFromNib() -> PopUpView {
        return UINib(nibName: "PopUpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PopUpView
    }
    
    fileprivate func transparencySetup() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: .light)
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(blurView)
            
        } else {
            self.backgroundColor = UIColor.white
        }
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sendSubview(toBack: blurView)
    }


}
