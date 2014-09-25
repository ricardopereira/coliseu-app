//
//  DownloadViewCell.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 25/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class DownloadViewCell: UITableViewCell
{
    // Fields
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelFilename: UILabel!

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

        labelFilename.text = filename
        labelFilename.lineBreakMode = NSLineBreakMode.ByCharWrapping
        labelFilename.numberOfLines = 0
        return self
    }
}
