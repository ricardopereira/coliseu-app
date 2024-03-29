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
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var imageDone: UIImageView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // For example: to associate delegates for fields
        imageDone.hidden = true
    }

    func configure(title: String, _ filename: String, _ progress: Float) -> UITableViewCell
    {        
        labelTitle.text = title
        labelTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        labelTitle.numberOfLines = 0
        labelTitle.accessibilityLabel = NSLocalizedString("Music title", comment: "")
        labelTitle.accessibilityValue = title

        labelFilename.text = filename
        labelFilename.lineBreakMode = NSLineBreakMode.ByCharWrapping
        labelFilename.numberOfLines = 0

        progressBar.progress = progress

        if progress == 1 {
            imageDone.image = StyleKit.imageOfDownloadDone
            imageDone.hidden = false
        }
        else {
            imageDone.hidden = true
        }

        return self
    }
}
