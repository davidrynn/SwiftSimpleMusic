//
//  PopUpView.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 4/20/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

protocol PopUpViewButtonDelegate {
    func artistButtonTapped()
    func albumButtonTapped()
}

protocol PopUpScrollDelegate {
    func scrollPopUpView()
}

class PopUpView: UIView {

    
    //topbar will possibly have fade in/out
    //image
    //button for up/down

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var topBarImageView: UIImageView!
    @IBOutlet weak var topBarLabel: UILabel!
  
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var artistButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet fileprivate weak var label: UILabel!
    
    var delegate: PopUpViewButtonDelegate?
    var popUpScrollDelegate: PopUpScrollDelegate?
    var topBarOpacity: CGFloat = 1.0
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
        self.imageView.frame = CGRect(x: self.width/6, y: self.height*2/3, width: self.width*2/3, height: self.height*2/6)
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
    
    @IBAction func artistButtonTapped(_ sender: Any) {
        self.delegate?.artistButtonTapped()
    }
    @IBAction func albumButtonTapped(_ sender: Any) {
        self.delegate?.albumButtonTapped()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.sendSubview(toBack: blurView)
        self.artistButton.frame = CGRect(x: 40, y: self.height - 140, width: 80, height: 45)
        self.artistButton.backgroundColor = UIColor.lightGray
        self.artistButton.dropShadow()
        self.albumButton.frame = CGRect(x: self.width - 120, y: self.height - 140, width: 80, height: 45)
        self.albumButton.backgroundColor = UIColor.lightGray
        self.albumButton.dropShadow()
        self.topBar.frame = CGRect(x: 0, y: 0, width: self.width, height: 60)
        self.topBarImageView.frame = CGRect(x: 5.0, y: 12.5, width: 35, height: 35)
        self.topBarLabel.frame = CGRect(x:50.0, y: 12.5, width: self.width - 50, height: 35)
        let sliderWidth = self.width*2/3
        self.slider.frame = CGRect(x: centeringOriginX(sliderWidth), y: self.height*2/3, width: sliderWidth, height: 40.0)
        self.label.frame = CGRect(x: centeringOriginX(sliderWidth), y: slider.origin.y - 45, width: sliderWidth, height: 40)
        self.label.textAlignment = .center
        self.imageView.frame = CGRect(x: self.slider.origin.x, y: 80, width: sliderWidth, height: sliderWidth)
        self.topBar.alpha = topBarOpacity
        self.topBarImageView.alpha = topBarOpacity
        self.topBar.dropShadow()
    }
    
    func centeringOriginX(_ objectWidth: CGFloat) -> CGFloat {
        return self.width/2 - (objectWidth)/2
    }


}
