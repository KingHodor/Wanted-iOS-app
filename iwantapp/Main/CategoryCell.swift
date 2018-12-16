//
//  CategoryCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 17.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var label: TopAlignedLabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.layer.borderWidth = 1
        //imageView.layer.borderWidth = 2
        self.image.backgroundColor = UIColor.clear
    }
}
