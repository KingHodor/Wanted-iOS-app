//
//  WantActivityCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 19.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class WantActivityCell: UITableViewCell {

    @IBOutlet weak var wantImgView: UIImageView!
    @IBOutlet weak var WantLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
