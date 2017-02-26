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
    var image: UIImage?{
        didSet {
            if let _ = imageView {
                imageView.image = image
            }
        }
    }
    
    @IBOutlet fileprivate weak var label: UILabel!
    var text: String? {
        didSet {
            if let _ = label {
                label.text = text
            }
        }
        
    }
    
    //TODO: figure out private/open button
    @IBOutlet weak var button: UIButton!
    
    
    
    
    class func instanceFromNib() -> PopUpTopBarView {
        return UINib(nibName: "PopUpTopBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PopUpTopBarView
    }
    
    //NOT NECESSARY?
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        self.bringSubviewToFront(label)
    //
    //    }
    
}
