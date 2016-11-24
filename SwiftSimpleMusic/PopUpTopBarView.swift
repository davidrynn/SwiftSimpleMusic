//
//  PopUpTopBarView.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 4/20/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit

class PopUpTopBarView: UIView {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    var image: UIImage {
        get {
            return imageView.image!
        }
        set {
            imageView.image = newValue
        }
    }
    
    @IBOutlet fileprivate weak var label: UILabel!
    var text: String {
        get {
            return label.text!
        }
        set {
            label.text = newValue
        }
    }
//TODO: figure out private/open button
    @IBOutlet weak var button: UIButton!
    
    
    
    
    class func instanceFromNib() -> PopUpTopBarView {
        return UINib(nibName: "PopUpBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PopUpTopBarView
    }
    
//NOT NECESSARY?
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.bringSubviewToFront(label)
//        
//    }

}
