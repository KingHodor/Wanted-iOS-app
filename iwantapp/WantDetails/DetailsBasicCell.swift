//
//  DetailsBasicCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 21.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class DetailsBasicCell: UITableViewCell {


    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
