//
//  WriterTableViewCell.swift
//  MapViewPOC
//
//  Created by Eric de Regter on 01-07-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit

class WriterTableViewCell: UITableViewCell {

    @IBOutlet var writerImage: UIImageView!
    
    @IBOutlet var lblWritername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        writerImage.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        writerImage.layer.cornerRadius = writerImage.bounds.width/2
        writerImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
