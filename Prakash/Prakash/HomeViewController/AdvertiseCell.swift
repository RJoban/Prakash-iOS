//
//  AdvertiseCell.swift
//  Prakash
//
//  Created by Ravi Jobanputra on 05/01/21.
//  Copyright © 2021 I. All rights reserved.
//

import UIKit

class AdvertiseCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

}
