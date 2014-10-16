//
//  SongViewCell.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 24/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class SongViewCell: UITableViewCell
{
    // Fields
    @IBOutlet weak var labelTitle: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // For example: to associate delegates for fields
        
    }

    func configure(title: String, _ filename: String) -> UITableViewCell
    {
        labelTitle.text = title
        labelTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        labelTitle.numberOfLines = 0
        labelTitle.accessibilityLabel = NSLocalizedString("Music title", comment: "")
        labelTitle.accessibilityValue = title
        return self
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()
        // ?
        //labelFilename.preferredMaxLayoutWidth = frame.width - 50
    }

    override var bounds : CGRect {
        didSet {
            // Fix autolayout constraints broken in Xcode 6 GM + iOS 7.1
            //self.contentView.frame = bounds
        }
    }
}