//
//  MusicTableViewCell.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 2/27/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    var cellModifier: CGFloat = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = self.imageView else { return }
        imageView.bounds = CGRect(x: 0, y: 0, width: imageView.width*cellModifier, height: imageView.height*cellModifier)
    }

}
